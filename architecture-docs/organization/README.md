# Organization Architecture

![Organization Architecture Diagram](../../docs/diagrams/account-structure.png)

AWS Organizations is used to create a multi-account setup and provide centralized management of all accounts. Organizational Units are used to further separate accounts that share similar security or resource needs. SCPs are attached at the OU level to establish the maximum available permissions for each account under each OU instead of redundantly attaching SCPs to individual accounts that share similar security needs. Attaching SCPs at the OU level decreases the number of policies administrators would have to manage and provides easier onboarding for new accounts.

## Requirements
- Different workloads and duties should be separated into their own account.
- The management account should be accessed by a select few of trust individuals.
- The root account should not be used after the organization is created.
- Dev, Test, and Prod environments must be separated into their own OUs.
- Accounts with similar security or resource needs should be located in a shared OU.
- New accounts must automatically be given the appropriate guardrails once added to an OU.

## Architecture Components

### Management Account
This account is in charge of managing all OUs and accounts. Administrators will use this account for centralized governance and billing for the entire organization.

### Security OU
This OU contains accounts that are used to store logs from all accounts and secure the entire organization from one place.
- Log Archive Account: Used to store logs from across all accounts for increased organization and visibility.
- Security Tooling Account: Used to configure security settings/policies, view security alerts, and set up remediations for noncompliant permissions across the entire organization.

### Infrastructure OU
This OU contains accounts used to operate and manage infrastructure.
- Network Account: Used to manage the network infrastructure.
- Backup Account: Used to manage and store copies of data across the organization.
- Monitoring Account: Used to monitor workloads and set up metrics for CloudWatch alarms.
- Identity Account: Used to centralize access management and be the delegated account for IAM Identity Center.
- Sandbox Account: Used by teams for experimental purposes.
  
### Workloads OU
This OU contains three other OUs (Dev, Test, and Prod) that will hold accounts for each workload. If workloads are closely related and have similar security measures, they can be put into the same account.

## Decisions & Trade-offs
- AWS Organizations is an optimal way to manage and govern several accounts for an environment at this scale in one place and it is free to use. AWS Organizations makes it easy for administrators to create permission boundaries for accounts and OUs using SCPs, streamlining security operations to keep the organization in line with the best security practices. AWS Organizations also includes consolidated billing for all accounts so you can receive one bill which can result in cost savings.
- Multiple accounts are used to create clear boundaries between different workloads and operations so that resources in each account are only accessed by authorized individuals.
- Dev, Test, and Prod environments are separated into their own OUs since each of these environments calls for different security measures. For example, generally production workloads will need stricter guardrails than development or test environments. Another design would be to separate the environments into production and non-production OUs, but I did not implement this design because I wanted to create as much separation between the environments as possible to decrease the blast radius in case of an attack.

## Traffic Flow

## Failure & Resilience Considerations

## Cost Considerations (if needed)
