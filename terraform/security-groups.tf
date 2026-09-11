resource "aws_vpc_security_group_ingress_rule" "allow_alb" {
  security_group_id              = module.banking_ecs_service.sg_id
  from_port                      = 80
  ip_protocol                    = "HTTP"
  to_port                        = 80
  referenced_security_group_id   = var.alb_security_group
}

resource "aws_vpc_security_group_egress_rule" "to_private_link_interface_endpoint" {
  security_group_id            = module.banking_ecs_service.sg_id
  from_port                    = var.provider_port
  protocol                     = "tcp"
  to_port                      = var.provider_port
  referenced_security_group_id = module.private_link.private_link_interface_endpoint
}

resource "aws_vpc_security_group_ingress_rule" "allow_nlb" {
  security_group_id              = module.payments_ecs_service.sg_id
  from_port                      = var.provider_port
  ip_protocol                    = "tcp"
  to_port                        = var.provider_port
  referenced_security_group_id   = module.private-link.nlb_sg
}

resource "aws_vpc_security_group_egress_rule" "to_provider" {
  security_group_id            = module.private_link.nlb_sg
  from_port                    = var.provider_port
  ip_protocol                  = "tcp"
  to_port                      = var.provider_port
  referenced_security_group_id = module.payments_ecs_service.sg_id
}
