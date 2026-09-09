variable "vpc_id" {
  description = "ID of the VPC where endpoints will be created"
  type        = string
}

variable "private_route_table_id" {
  description = "ID of the private route table"
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

variable "ecs_security_group" {
  description = "Security group ID for ecs tasks"
  type        = string
}
