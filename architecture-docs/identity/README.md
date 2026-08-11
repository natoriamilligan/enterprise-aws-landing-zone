# Access Flow Architecture

User identities are stored in an external identity provider which is connected to AWS IAM Identity Center. Users authenticate through the external identity provider using single sign-on which will then connect to IAM Identity Center for AWS access. Permission sets will be given to groups or individuals for appropriate access to assigned accounts and resources. 

## Requirements
- Users must only have one set of credentials.
- Users must not share credentials for access to the same account.
- Users must be added to groups in the IdP when appropriate.
- Users must authenticate through an IdP using SSO.
- The source of identities should belong to the IdP.
- Users must only take on one role at a time in each account.
- Users must be able to have access to multiple accounts and roles if needed.

## Architecture Components
### AWS IAM Identity Center

### Permission Sets


## Decisions & Trade-offs
- The source of identities are kept out of AWS so that
- IAM Identity Center was chosen so that the organization can centrally manage and secure access to multiple accounts. Enterprises commonly have an existing identity provider which can connect IAM Identity Center so that there is only one source of truth for identities.
  
## Failure & Resilience Considerations

## Cost Considerations
