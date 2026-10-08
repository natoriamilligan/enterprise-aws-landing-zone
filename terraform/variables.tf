variable "provider_port" {
  description = "Port used for ECS services"
  type        = string
  default     = "8000"
}

variable "region" {
  description = "Region where infrastructure is deployed"
  type        = string
  default     = "us-east-2"
}
