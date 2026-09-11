resource "aws_vpc_security_group_ingress_rule" "allow_alb" {
  security_group_id = var.ecs_security_group_id
  from_port         = 80
  ip_protocol       = "HTTP"
  to_port           = 80
  security_groups   = var.alb_security_group
}
