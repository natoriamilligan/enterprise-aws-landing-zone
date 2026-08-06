# Enterprise AWS Landing Zone
This project presents a secure, multi-account AWS landing zone for a financial enterprise environment. This project includes diagrams and architectural decisions of proper governance, networking, identity and access management, security, logging, and monitoring flows commonly found in enterprise AWS environments. This is an architecture-first project currently being implemented with Terraform.

## Organization Architecture
![Organization Architecture Diagram](./docs/diagrams/account-structure.png)

I implemented AWS Organizations to create a multi-account setup and provide centralized management of all accounts. Organizational Units are used to further separate accounts that share similar security or resource needs. Enterprises consist of several teams, workloads, and business operations so it is important to isolate these entities using different accounts. With AWS Organizations, you can attach SCPs to OUs to establish the maximum available permissions for each account under them instead of redundantly attaching SCPs to individual accounts that share similar security needs. Attaching SCPs to OUs also decreases the number of policies you would have to modify and provides easier onboarding for new accounts.

### Management Account
This account is in charge of managing all OUs and accounts. Teams can use this account for centralized governance and billing for the entire organization.

### Security OU
This OU contains accounts that are used to store logs from all accounts and secure the entire organization from one place.
- Log Archive Account: Used to store logs from across all accounts for better organization and visibility.
- Security Tooling Account: Used to configure security settings/policies, view security alerts, and set up remediations for out-of-compliance permissions across the entire organization.
  
### Infrastructure OU
This OU contains accounts used to operate and manage infrastructure.
- Network Account: Used by teams to manage the network infrastructure.
- Backup Account: Used to manage and store copies of data across the organization.
- Monitoring Account: Used to monitor workloads and set up metrics for CloudWatch alarms.
- Identity Account: Used to centralize access management and be the delegated account for IAM Identity Center.
- Sandbox Account: Used by teams for experimental purposes.

### Workloads OU
This OU contains three other OUs (Dev, Test, and Prod) that will hold accounts for each workload. If workloads are closely related and have similar security measures, they can be put into the same account.

## Network Architecture
![Networking Architecture Diagram](./docs/diagrams/networking.png)

## Security, Observability, & Audit Architecture
![Security Observability & Audit Architecture Diagram](./docs/diagrams/security-observability-audit.png)

## Access Flow Architecture
![Access Flow Architecture Diagram](./docs/diagrams/access-flow.png)


