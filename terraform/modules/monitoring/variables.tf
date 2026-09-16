variable "banking_cluster_name" {
  description = "Name of the ECS banking cluster"
  type        = string
}

variable "banking_service_name" {
  description = "Name of the ECS banking service"
  type        = string
}

variable "payments_cluster_name" {
  description = "Name of the ECS payments cluster"
  type        = string
}

variable "payments_service_name" {
  description = "Name of the ECS payments service"
  type        = string
}

variable "email_address" {
  description = "Email address for SNS notifications to be sent to"
  type        = string
}

variable "endpoint_id" {
  description = "ID of the consumer interface endpoint"
  type        = string
}

variable "endpoint_service_id" {
  description = "ID of the private link endpoint service"
  type        = string
}

variable "alb_arn_suffix" {
  description = "ARN suffix of the ALB"
  type        = string
}

variable "alb_target_group_arn_suffix" {
  description = "ARN suffix of the ALB target group"
  type        = string
}

variable "nlb_arn_suffix" {
  description = "ARN suffix of the NLB"
  type        = string
}

variable "nlb_target_group_arn_suffix" {
  description = "ARN suffix of the NLB target group"
  type        = string
}
