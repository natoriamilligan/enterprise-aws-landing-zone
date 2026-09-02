variable "vpc_cidr_block" {
  description = "CIDR block for VPC."
  type        = string
}

variable "public_subnet_a" {
  description = "CIDR block for public subnet A."
  type        = string
}

variable "public_subnet_b" {
  description = "CIDR block for public subnet B."
  type        = string
}

variable "private_subnet_a" {
  description = "CIDR block for private subnet A."
  type        = string
}

variable "private_subnet_b" {
  description = "CIDR block for private subnet B."
  type        = string
}

variable "subnet_az_a" {
  description = "AZ for subnet A."
  type        = string
}

variable "subnet_az_b" {
  description = "AZ for subnet B."
  type        = string
}
