resource "aws_ecs_cluster" "app_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_iam_role" "task_execution_role" {
  name               = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "AWS_managed_task_policy" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = var.ecs_log_group_name
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = var.ecs_family_name
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu 
  memory                   = var.ecs_memory
  container_definitions    = jsonencode([
    {
      name             = var.ecs_container_name
      image            = var.image_name
      cpu              = var.ecs_container_cpu
      essential        = true
      portMappings     = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_security_group" "app_task_sg" {
  name        = var.app_task_sg
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_alb" {
  security_group_id = aws_security_group.app_task_sg.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  security_groups   = var.alb_security_group
}

resource "aws_vpc_security_group_egress_rule" "tasks_to_endpoints" {
  security_group_id = aws_security_group.app_task_sg.id
  from_port         = 443
  protocol          = "tcp"
  to_port           = 443
  security_groups   = var.endpoints_sg
}

resource "aws_ecs_service" "app-service" {
  name                              = var.app_service_name
  cluster                           = aws_ecs_cluster.app_cluster.id
  task_definition                   = aws_ecs_task_definition.app_task.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.app_task_sg.id]
    subnets          = [var.private_subnet_a, var.private_subnet_b]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.ecs_container_name
    container_port   = var.container_port
  }
}
