# Network Architecture

![Access Flow Diagram](../../docs/diagrams/networking.png)

This network diagram illustrates three production workloads that reside in separate accounts and VPCs. The VPCs expose their services using PrivateLink to limit the amount of connectivity between them. All workloads in these diagrams are deployed as Amazon ECS services running on AWS Fargate.

## Requirements


## Architecture Components
### Digital Banking VPC
This VPC consists of both public and private subnets. The public subnet holds an application load balancer to provide an entry point to the workloads held in the private subnets.  

The account where this VPC lies holds the CloudFront distribution and S3 bucket where the front-end files will be stored. CloudFront will use edge locations for decreased latency and fast delivery of the files stored in S3. Both the ALB and CloudFront use WAF to help monitor and control access to these public entry points.

### Payments VPC
This VPC only consists of private subnets. The Digital Banking VPC will need to access payment information from the workloads in this VPC. This connection is established through an interface endpoint, PrivateLink, and a network load balancer. The NLB provides the entry point for the payment workloads and must also reside in a private subnet.

### Fraud VPC
This VPC also consists of private subnets only. The workloads in this VPC are accessed by the workloads in the previous two VPCs. The workloads in the other VPCs will send information such as sign in attempts and transaction data to this VPC so the fraud workloads can investigate any suspicious activity. The NLB again provides an entry point to these workloads.

### Interface/Gateway Endpoints
I have added several other interface endpoints to each VPC the containers can access AWS services securely using PrivateLink instead of exposing them to the internet. The containers need to send logs to CloudWatch and also pull images from ECR and S3. The interface endpoints will be deployed across two AZs. Deploying two centralized NAT Gateways instead would reduce costs, however the architecture would have to be redesigned to allow connectivity between all VPCs using Transit Gateway. I specifically did not use Transit Gateway because the VPCs do not need broad connectivity with each other. Also, interface endpoints reduce the attack surface for this network. Two NAT gateways deployed in each VPC could also be an option but a very expensive one.

S3 gateway endpoints do not use PrivateLink like regular interface endpoints. Gateway endpoints connect directly to the service and are completely free to use so I made sure to add those where needed.

## Decisions & Trade-offs
- ECS Fargate is used for the workloads to minimize operational overhead.
  
## Failure & Resilience Considerations

## Cost Considerations
