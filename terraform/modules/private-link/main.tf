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

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}
