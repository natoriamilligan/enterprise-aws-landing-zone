variable "ecs_cluster_name" {
  description = "Name of ECS cluster"
  type        = string
}

variable "ecs_task_execution_role_name" {
  description = "Name of the ECS task execution role"
  type        = string
}

variable "ecs_log_group_name" {
  description = "Name of ECS log group"
  type        = string
}

variable "ecs_ecs_family_name" {
  description = "Name of ECS family"
  type        = string
}

variable "ecs_task_cpu" {
  description = "Amount of CPU for the ECS task"
  type        = string
}

variable "ecs_memory" {
  description = "Amount of memory for the ECS task"
  type        = string
}

variable "ecs_container_name" {
  description = "Name of ECS container"
  type        = string
}

variable "image_name" {
  description = "Name of image used in ECS task definition"
  type        = string
}

variable "ecs_container_cpu" {
  description = "Amount of CPU given to each container"
  type        = number
}

variable "container_port" {
  description = "Port for container"
  type        = number
}

variable "host_port" {
  description = "Port for host"
  type        = number
}

variable "region" {
  description = "Region for ECS service"
  type        = string
}

variable "app_task_sg" {
  description = "Security group ID for the task"
  type        = string
}

variable "vpc_id" {
  description = "ID for the VPC"
  type        = string
}

variable "alb_security_group" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "endpoints_sg" {
  description = "Security group ID for the endpoints"
  type        = string
}

variable "app_service_name" {
  description = "Name of ECS service"
  type        = string
}

variable "private_subnet_a" {
  description = "ID of subnet A"
  type        = string
}

variable "private_subnet_b" {
  description = "ID of subnet B"
  type        = string
}

variable "alb_target_group_arn" {
  description = "ARN for ALB target group"
  type        = string
}
