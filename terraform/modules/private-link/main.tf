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
  vpc_id   = var.vpc_id
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
