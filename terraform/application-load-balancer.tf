resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = module.banking_vpc.vpc_id
}

resource "aws_lb" "alb" {
  name               = "alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [
    module.banking_vpc.private_subnet_a,
    module.banking_vpc.private_subnet_b
  ]
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.banking_vpc.vpc_id

  health_check {
    path        = "/home"
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_alb_https" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "alb_to_ecs" {
  security_group_id             = aws_security_group.alb_sg.id
  from_port                     = 80
  ip_protocol                   = "tcp"
  to_port                       = 80
  referenced_security_group_id  = module.banking_ecs_service.sg_id
}
