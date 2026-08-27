# Security, Observability, & Audit Architecture

![Organization Architecture Diagram](../../docs/diagrams/security-observability-audit.png)

These diagrams represent how threats are detected and remediated, how containers and supporting resources are monitored for troubleshooting, and how security logs are stored for the entire organization.

## Requirements
- All security threats should be aggregated into one central place.
- When appropriate, resources should be remediated automatically without human intervention.
- Only high-risk security threats should be alerted on.
- Metrics from containers, databases, and supporting resources must be created for alerts.
- Dashboards should be used for a centralized view of workload metrics.
- All security related logs should be stored in a centralized place.
- Security logs must be tightly secured and only accessible from trusted individuals.

## Architecture Components
### AWS Security Hub
AWS Security Hub gathers findings from Amazon GuardDuty, Amazon Inspector, and IAM Access Analyzer in one place for the entire organization.

### Amazon EventBridge
AWS Security Hub will send alerts to Amazon EventBridge which will filter which resources need to be remediated using AWS Systems Manager and/or which findings should be sent to Amazon SNS for teams to be alerted.

### AWS Systems Manager
Amazon EventBridge will trigger an automation to remediate out of compliance policies, security groups, and other vulnerabilities that are time sensitive so that security teams can focus on other threats that need human intervention.

### Amazon CloudWatch
CloudWatch Logs will be used for monitoring and troubleshooting of containers, databases, and other network resources. Metrics will be set so alarms can be triggered if any workload or resource needs attention. CloudWatch Dashboards will provide a centralized view of key metrics across workloads to help teams collaborate and respond to incidents effectively.

### S3 + Athena
All security related logs will be stored in a single S3 bucket for forensic investigations and archiving. Amazon Athena will be used to query and analyze the logs without any infrastructure management.

## Decisions & Trade-offs
- AWS Security Hub is used to gather findings from different services, so security teams don’t have to check each console individually which saves them time. Security Hub also sends findings to EventBridge seamlessly instead of configuring each security service to integrate with EventBridge.
- AWS System Manager Automation is used instead of Lambda for remediation so that code does not have to be written and maintained. Automation runbooks are designed to easily remediate resources and AWS provides runbooks for common operations.
- AWS GuardDuty, Amazon Inspector, and IAM Access Analyzer will help keep resources secure throughout the organization through continuous monitoring. Without these services, you would have to manually create a threat detection system for all resources which would take a long time for an enterprise. Also, every time a new resource is added or a workload expands, the threat detection system would need to be modified.
- All security logs are located in a centralized place which strengthens the operations for monitoring and controlling access to the bucket. Scattering the logs across several buckets would introduce additional policies to manage which would increase the chance of policy errors.
- Amazon Athena is used to query the security log bucket because it requires no infrastructure management and can query S3 buckets easily using SQL.
  
## Failure & Resilience Considerations
- The S3 log archive bucket can be secured through S3 Object Lock, bucket policies, and versioning. Objects are encrypted by default using SSE-S3 AWS KMS keys can also be used. Only a select few of trusted individuals will have access to the logs in this bucket. Any changes to IAM policies will go through a strict review process and will follow the principal of least privilege.
- If a resource remediation fails, teams will be notified so they can complete the process immediately.
- The security account will be tightly secured so that Security Hub cannot be reachable from unauthorized individuals. Guardrails will be set to prevent any changes to the services located in the security account.
- Failure of SNS does not result in lost findings, all findings are kept in Security Hub for investigation.
- Any remediation to production workloads will require manual approval before execution.
- CloudWatch metrics and alarms will notify if any workload needs attention such as unhealthy resources.
- Notifications from EventBridge and CloudWatch should be periodically tested in case of a path failure.

## Cost Considerations
- S3 Lifecycle policies will transition log archives to the appropriate storage class based on retention standards for the company to save costs.
- The log archive bucket will be compressed and partitioned appropriately for Amazon Athena to efficiently query to save costs.
- Security Hub is an added expense that charges based on resources monitored and threat analytics through GuardDuty. The GuardDuty add-on will be used instead of the standalone service.
