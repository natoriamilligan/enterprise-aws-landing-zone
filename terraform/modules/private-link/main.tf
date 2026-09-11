resource "aws_lb" "nlb" {
  name               = var.nlb_name
  internal           = true
  load_balancer_type = "network"
  subnets            = [var.private_subnet_a, var.private_subnet_b]
  security_groups    = [aws_security_group.nlb_sg.id]
}

resource "aws_security_group" "nlb_sg" {
  name        = var.nlb_sg_name
  vpc_id      = var.nlb_vpc
}

resource "aws_lb_target_group" "nlb" {
  name     = var.nlb_tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.nlb_vpc
}

resource "aws_lb_listener" "nlb" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb.arn
  }
}

resource "aws_vpc_endpoint_service" "nlb" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.nlb.arn]
}

resource "aws_vpc_endpoint_service_allowed_principal" "authorized_acct" {
  vpc_endpoint_service_id = aws_vpc_endpoint_service.nlb.id
  principal_arn           = var.allowed_principal_arn
}

resource "aws_vpc_endpoint" "private_link" {
  vpc_id            = var.consumer_vpc
  service_name      = aws_vpc_endpoint_service.nlb.service_name
  vpc_endpoint_type = "Interface"
  
  private_dns_enabled = true

  policy = data.aws_iam_policy_document.endpoint_service_policy.json
}

resource "aws_vpc_endpoint_security_group_association" "private_link" {
  vpc_endpoint_id   = aws_vpc_endpoint.private_link.id
  security_group_id = aws_security_group.private_link.id
}

resource "aws_vpc_endpoint_subnet_association" "private_link_private_a" {
  vpc_endpoint_id = aws_vpc_endpoint.private_link.id
  subnet_id       = var.private_subnet_a
}

resource "aws_vpc_endpoint_subnet_association" "private_link_private_b" {
  vpc_endpoint_id = aws_vpc_endpoint.private_link.id
  subnet_id       = var.private_subnet_b
}
