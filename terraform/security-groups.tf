resource "aws_vpc_security_group_ingress_rule" "allow_alb" {
  security_group_id              = module.banking_ecs_service.sg_id
  from_port                      = 8000
  ip_protocol                    = "tcp"
  to_port                        = 8000
  referenced_security_group_id   = aws_security_group.alb_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ecs_to_endpoint" {
  security_group_id             = module.private_link.private_link_interface_endpoint_sg
  from_port                     = var.provider_port
  ip_protocol                   = "tcp"
  to_port                       = var.provider_port
  referenced_security_group_id  = module.banking_ecs_service.sg_id
}

resource "aws_vpc_security_group_egress_rule" "to_private_link_interface_endpoint" {
  security_group_id            = module.banking_ecs_service.sg_id
  from_port                    = var.provider_port
  ip_protocol                     = "tcp"
  to_port                      = var.provider_port
  referenced_security_group_id = module.private_link.private_link_interface_endpoint_sg
}

resource "aws_vpc_security_group_ingress_rule" "allow_nlb" {
  security_group_id              = module.payments_ecs_service.sg_id
  from_port                      = var.provider_port
  ip_protocol                    = "tcp"
  to_port                        = var.provider_port
  referenced_security_group_id   = module.private_link.nlb_sg
}

resource "aws_vpc_security_group_egress_rule" "to_provider" {
  security_group_id            = module.private_link.nlb_sg
  from_port                    = var.provider_port
  ip_protocol                  = "tcp"
  to_port                      = var.provider_port
  referenced_security_group_id = module.payments_ecs_service.sg_id
}
