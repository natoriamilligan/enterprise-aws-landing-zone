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
  route_table_id  = var.private_aws_route_table
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = var.aws_vpc
  service_name      = "com.amazonaws.us-east-2.ecr.api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.sg1.id,
  ]
  
  private_dns_enabled = true
}
