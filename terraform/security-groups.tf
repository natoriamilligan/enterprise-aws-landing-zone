resource "aws_vpc_security_group_ingress_rule" "allow_alb" {
  security_group_id = module.banking_ecs_service.sg_id
  from_port         = 80
  ip_protocol       = "HTTP"
  to_port           = 80
  security_groups   = var.alb_security_group
}

resource "aws_vpc_security_group_ingress_rule" "allow_nlb" {
  security_group_id = module.payments_ecs_service.sg_id
  from_port         = var.provider_port
  ip_protocol       = "tcp"
  to_port           = var.provider_port
  security_groups   = module.private-link.nlb_sg
}

