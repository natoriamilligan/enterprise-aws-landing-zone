# Access Flow Architecture

![Access Flow Diagram](../../diagrams/access-flow.png)
User identities are stored in an external identity provider which is connected to AWS IAM Identity Center. Users authenticate through the external identity provider using single sign-on which will then connect to IAM Identity Center for AWS access. Permission sets will be given to groups or individuals for appropriate access to assigned accounts and resources. This design streamlines the process for modifying, assigning, and removing permission sets and makes the onboarding and offboarding process more secure. Additionally, with separate credentials, administrators will be able to monitor exactly who is accessing AWS at all times.

## Requirements
- Users must only have one set of credentials.
- Users must not share credentials for access to the same account.
- Users must be added to groups in the IdP when appropriate.
- Users must authenticate through an IdP using SSO.
- The source of identities should belong to the IdP.
- Users must only take on one role at a time in each account.
- Users must be able to have access to multiple accounts and roles if needed.

## Architecture Components
### AWS IAM Identity Center & Permission Sets
IAM Identity Center is used to centrally manage and secure access to AWS accounts and resources. Access to IAM Identity Center will be restricted to a small group of trusted individuals. Administrators will create permission sets through IAM Identity Center that will be used to define the roles users can assume in each assigned account. Permission sets will be created based on the groups that will be assigned to them unless a permission sets for individuals are needed.

## Decisions & Trade-offs
- IAM Identity Center was chosen so that the organization can centrally manage and secure access to multiple accounts. 
- The source of identities are kept out of AWS so that there is only one source of truth instead of employees separate credentials for AWS.
- Permission sets will be assigned to groups and only to individuals when appropriate.
  
## Failure & Resilience Considerations
- If there is a compromise in IAM Identity Center, the source of identities are stored in the IdP which can be re-synced with IAM Identity Center.
- IAM Identity Center is deployed across multiple Availability Zones so that organizations can reach AWS even if there is an AZ disruption.
- CloudTrail will document any IAM Identity Center API activity so administrators can monitor any breaches or accidents.

## Cost Considerations
- IAM Identity Center is completely free to use.
