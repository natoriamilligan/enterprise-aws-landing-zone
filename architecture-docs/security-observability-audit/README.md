# Security, Observability, & Audit Architecture

![Organization Architecture Diagram](../../docs/diagrams/security-observability-audit.png)

These diagrams represent how threats are detected and remediated, how containers and supporting resources are monitored for troubleshooting, and how security logs are stored for the entire organization.

## Requirements
- All security threats should be aggregated into one central place
- When appropriate, resources should be remediated automatically without human intervention
- Only high-risk security threats should be alerted on
- Metrics from containers, databases, and supporting resources must be created for alerts
- Dashboards should be used for a centralized view of workload metrics
- All security related logs should be stored in a centralized place
- Security logs must be tightly secured and only accessible from trusted individuals

## Architecture Components
### AWS Security Hub
AWS Security Hub gathers findings from Amazon GuardDuty, Amazon Inspector, and IAM Access Analyzer in one place for the entire organization so security teams don’t have to check each service individually.

### Amazon EventBridge
AWS Security Hub will send alerts to Amazon EventBridge which will filter which resources need to be remediated using AWS Systems Manager and/or which findings should be sent to Amazon SNS for teams to be alerted.

### AWS Systems Manager
Amazon EventBridge will trigger an automation to remediate out of compliance policies, security groups, and other vulnerabilities that are time sensitive so that security teams can focus on other threats that need human intervention.

### Amazon CloudWatch
CloudWatch Logs will be used for monitoring and troubleshooting of containers, databases, and other network resources. Metrics will be set so alarms can be triggered if any workload or resource needs attention. CloudWatch Dashboards will provide a centralized view of key metrics across workloads to help teams collaborate and respond to incidents effectively.

### S3 + Athena
All security related logs will be stored in a single S3 bucket for forensic investigations and archiving. Amazon Athena will be used to query and analyze the logs without any infrastructure management.

## Decisions & Trade-offs

## Failure & Resilience Considerations

## Cost Considerations
