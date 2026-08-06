# Enterprise AWS Landing Zone
This project presents a secure, multi-account AWS landing zone for a financial enterprise environment. This project includes diagrams and architectural decisions of proper governance, networking, identity and access management, security, logging, and monitoring flows commonly found in enterprise AWS environments. This is an architecture-first project currently being implemented with Terraform.

## Organization Architecture
![Organization Architecture Diagram](./docs/diagrams/account-structure.png)

## Network Architecture
![Networking Architecture Diagram](./docs/diagrams/networking.png)

## Security, Observability & Audit Architecture
![Security Observability & Audit Architecture Diagram](./docs/diagrams/security-observability-audit.png)

## Access Flow Architecture
![Access Flow Architecture Diagram](./docs/diagrams/access-flow.png)

### Management Account
This account is in charge of all OUs and accounts. Teams can use this account for centralized governance and billing for the entire organization. This account does not sit inside an OU.
### Security OU
This OU contains accounts that are used to store logs from all accounts and secure the entire organization from one place.
- Logs Account: Used to gather and store logs from across all accounts for better organization and visibility.
- Security/Audit Account: Used to configure security settings/policies, view security alerts, and set up remidiations for out-of-compliance permissions.
### Infrastructure OU
This OU contains accounts used to operate and manage infrastructure.
- Network Account: Used by teams to manage the network infrastructure.
- Backup Account: Used to manage and store copies of data across the organization.
- Monitoring Account: Controls access to each account.
- Identity Account: Monitors all resources and workloads.
- Sandbox Account: Used by teams for experimentation purposes.
### Workloads OU
This OU contains two other OUs (Prod and Non-Prod) that will hold accounts for each workload. If workloads are closely related and have similar security measures, they can be put into the same account.
