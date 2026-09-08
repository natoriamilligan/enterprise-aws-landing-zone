resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.aws_vpc
  service_name = "com.amazonaws.us-east-2.s3"

  policy = jsonencode({
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
  
        Resource = "arn:aws:s3:::prod-us-east-2-starport-layer-bucket/*"
      }
    ]
  })
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  route_table_id  = var.private_route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_security_group" "endpoints" {
  description = "Allow inbound traffic from ECS service on port 443"
  vpc_id      = var.aws_vpc
}

resource "aws_vpc_security_group_ingress_rule" "allow_ecs" {
  security_group_id = aws_security_group.endpoints.id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  security_groups   = var.ecs_security_group
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.endpoints.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = var.aws_vpc
  service_name      = "com.amazonaws.us-east-2.ecr.api"
  vpc_endpoint_type = "Interface"
  
  private_dns_enabled = true

  policy = data.aws_iam_policy_document.ecr_endpoint_policy.json
}

resource "aws_vpc_endpoint_security_group_association" "ecr_api" {
  vpc_endpoint_id   = aws_vpc_endpoint.ecr_api.id
  security_group_id = aws_security_group.endpoints.id
}

resource "aws_vpc_endpoint_subnet_association" "ecr_api_private_a" {
  vpc_endpoint_id = aws_vpc_endpoint.ecr_api.id
  subnet_id       = var.private_subnet_a
}

resource "aws_vpc_endpoint_subnet_association" "ecr_api_private_b" {
  vpc_endpoint_id = aws_vpc_endpoint.ecr_api.id
  subnet_id       = var.private_subnet_b
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = var.aws_vpc
  service_name      = "com.amazonaws.us-east-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
  
  private_dns_enabled = true
  policy = data.aws_iam_policy_documents.ecr_endpoint_policy.json
}

resource "aws_vpc_endpoint_security_group_association" "ecr_dkr" {
  vpc_endpoint_id   = aws_vpc_endpoint.ecr_dkr.id
  security_group_id = aws_security_group.endpoints.id
}

resource "aws_vpc_endpoint_subnet_association" "ecr_dkr_private_a" {
  vpc_endpoint_id = aws_vpc_endpoint.ecr_dkr.id
  subnet_id       = var.private_subnet_a
}

resource "aws_vpc_endpoint_subnet_association" "ecr_dkr_private_b" {
  vpc_endpoint_id = aws_vpc_endpoint.ecr_dkr.id
  subnet_id       = var.private_subnet_b
}

resource "aws_vpc_endpoint" "cw_logs" {
  vpc_id            = var.aws_vpc
  service_name      = "com.amazonaws.us-east-2.logs"
  vpc_endpoint_type = "Interface"
  
  private_dns_enabled = true
  policy = data.aws_iam_policy_documents.cw_endpoint_policy.json
}

resource "aws_vpc_endpoint_security_group_association" "cw_logs" {
  vpc_endpoint_id   = aws_vpc_endpoint.cw_logs.id
  security_group_id = aws_security_group.endpoints.id
}

resource "aws_vpc_endpoint_subnet_association" "cw_private_a" {
  vpc_endpoint_id = aws_vpc_endpoint.cw_logs.id
  subnet_id       = var.private_subnet_a
}

resource "aws_vpc_endpoint_subnet_association" "cw_private_b" {
  vpc_endpoint_id = aws_vpc_endpoint.cw_logs.id
  subnet_id       = var.private_subnet_b
}
