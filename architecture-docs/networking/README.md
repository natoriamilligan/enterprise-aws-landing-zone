# Network Architecture

![Access Flow Diagram](../../docs/diagrams/networking.png)

This network diagram illustrates three production workloads that reside in separate accounts and VPCs. The VPCs expose their services using PrivateLink to limit the amount of connectivity between them. All workloads in these diagrams are deployed as Amazon ECS services running on AWS Fargate.

## Requirements
- All VPCs must be separated.
- Workloads must be accessed securely by external sources.
- Workloads must run in containers that are low maintenance.
- Workloads must be able to scale automatically.
- Workloads must exist in private subnets.
- All public facing resources should be properly secured and monitored.
- Workloads should not access the public internet.
- IPv4 and IPv6 must be enabled.

## Architecture Components
### Digital Banking VPC
This VPC consists of both public and private subnets. The public subnet holds an Application Load Balancer to provide an entry point to the workloads held in the private subnets.  

The account where this VPC lies holds the CloudFront distribution and S3 bucket where the front-end files will be stored. CloudFront will use edge locations for decreased latency and fast delivery of the files stored in S3. Both the ALB and CloudFront use WAF to help monitor and control access to these public entry points.

### Payments VPC
This VPC only consists of private subnets. The Digital Banking VPC will need to access payment information from the workloads in this VPC. This connection is established through an interface endpoint, PrivateLink, and a Network Load Balancer. The NLB provides the entry point for the payment workloads and must also reside in a private subnet.

### Fraud VPC
This VPC also consists of private subnets only. The workloads in this VPC are accessed by the workloads in the previous two VPCs. The workloads in the other VPCs will send information such as sign in attempts and transaction data to this VPC so the fraud workloads can investigate any suspicious activity. The NLB again provides an entry point to these workloads.

### Interface Endpoints
There are several interface endpoints in each VPC so the containers can access AWS services securely using PrivateLink instead of exposing them to the internet. The containers need to send logs to CloudWatch and also pull images from ECR and S3. 

## Decisions & Trade-offs
- ECS Fargate is used for the workloads to minimize operational overhead to help reduce potential mistakes that can affect the integrity of the network.
- Interface endpoints are used instead of NAT Gateways to reduce the attack surface for this network. PrivateLink exposes only the services needed instead of establishing full network connectivity. Deploying two centralized NAT Gateways instead would reduce costs, however the architecture would have to be redesigned to allow connectivity between all VPCs using Transit Gateway, which would increase costs further. I specifically did not use Transit Gateway because the VPCs do not need broad connectivity with each other. Two NAT gateways deployed in each VPC could also be an option but a very expensive one. Transit Gateway however is a great option for large enterprise environments with hundreds of workloads and on-premise networks. A VPC Peering connection is also not used because it is not scalable and again, the VPCs so not need broad connectivity to each other. 
- S3 Gateway endpoints are used instead of interface endpoints to connect the workloads directly to S3, free of charge.
- The VPCs are isolated so that if one is compromised, the limited connectivity will reduce the scope of access for attackers. Fintech environments must prioritize security and separation of duties.
- All networks will have IPv6 enabled to support future growth.
- AWS Shield Standard is used in this network for reduced costs; however financial institutions are one of the most targeted entities for DDoS attacks since the websites are highly available and they handle large amounts of transactions every day. I highly recommend AWS Shield Advanced to be enabled in production environments for added DDoS protection.
- AWS WAF is added to the Application Load Balancers and Amazon CloudFront to monitor, protect, and control access to the web applications. Without AWS WAF, the web applications could become vulnerable if other protective measures aren't in place.
- Amazon Route 53 is used as the DNS for smooth compatibility with AWS infrastructure.
  
## Failure & Resilience Considerations
- Each VPC will span at least two AZs with one public and one private subnet per AZ. 
- The load balancer health checks monitor which ECS targets are healthy to send traffic to. The load balancers will stop sending traffic to any unhealthy targets.
- The load balancers and interface endpoints will be deployed across at least two AZs for increased availability.
- Amazon CloudFront caches content at edge locations around the world. If one server goes down, CloudFront can route requests to other locations.

## Cost Considerations
- S3 Gateway endpoints are free of charge.
