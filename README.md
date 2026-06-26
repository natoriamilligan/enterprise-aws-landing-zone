# Enterprise AWS Landing Zone
A production-inspired reference architecture demonstrating how an enterprise AWS platform can be designed. This project includes diagrams and architectural decisions of proper governance, networking, identity and access management, security, logging, and monitoring flows commonly found in enterprise AWS environments.

## Account Structure
### Management Account
### Security OU
This OU contains accounts that are used to store logs from all accounts and secure the entire organization from one place.
- Logs Account: Used to gather and store logs from accross all accounts for better organization and visibility
- Security/Audit Account: Used to configure security settings/policies, view security alerts, and set up remidiations for out-of-compliance permissions
### Infrastructure OU
This OU contains accounts used to operate and manage infrastructure.
- Network Account: Used by teams to manage the network infrastructure
- Backup Account: Used to manage and store copies of data across the organization 
- Monitoring Account: Controls access to each account
- Identity Account: Monitors all resources and workloads
- Sandbox Account: Used by teams for experimentation purposes
### Workloads OU
This OU contains two other OUs (Prod and Non-Prod) that will hold accounts for each workload. If workloads are closely related and have similar security measures, they can be put into the same account.
