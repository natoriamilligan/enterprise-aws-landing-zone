variable "nlb_name" {
  description = "Name of the network load balancer in the provider VPC"
  type        = string
}

variable "private_subnet_a" {
  description = "ID of private subnet A"
  type        = string
}

variable "private_subnet_b" {
  description = "ID of private subnet B"
  type        = string
}

variable "nlb_sg_name" {
  description = "Name of the NLB security group"
  type        = string
}

variable "nlb_vpc" {
  description = "Provider VPC ID"
  type        = string
}

variable "consumer_vpc_cidr_block" {
  description = "CIDR block for the consumer VPC"
  type        = string
}

variable "provider_port" {
  description = "Port used of the provider service"
  type        = string
}

variable "nlb_tg_name" {
  description = "Name of the NLB target group"
  type        = string
}

variable "allowed_principal_arn" {
  description = "ARN of the AWS account that will use the endpoint service"
  type        = string
}

variable "consumer_vpc" {
  description = "Consumer VPC ID"
  type        = string
}

variable "vpc_endpoint_sg_name" {
  description = "Name of interface endpoint used to connect to PrivateLink"
  type        = string
}

variable "consumer_ecs_security_group" {
  description = "Security group ID for the ecs service in consumer VPC"
  type        = string
}
