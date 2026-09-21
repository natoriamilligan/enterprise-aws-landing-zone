module "banking_vpc" {
  source           = "./modules/vpc"

  vpc_cidr_block   = "10.10.0.0/16"

  public_subnet_a  = "10.10.1.0/24"
  public_subnet_b  = "10.10.2.0/24"

  private_subnet_a = "10.10.101.0/24"
  private_subnet_b = "10.10.102.0/24"

  subnet_az_a      = "us-east-1a"
  subnet_az_b      = "us-east-1b"
}

module "payments_vpc" {
  source           = "./modules/vpc"

  vpc_cidr_block   = "10.20.0.0/16"

  public_subnet_a  = "10.20.1.0/24"
  public_subnet_b  = "10.20.2.0/24"

  private_subnet_a = "10.20.101.0/24"
  private_subnet_b = "10.20.102.0/24"

  subnet_az_a      = "us-east-1a"
  subnet_az_b      = "us-east-1b"
}

module "banking_vpc_endpoints" {
  source                 = "./modules/endpoints"

  vpc_id                 = module.banking_vpc.vpc_id
  private_route_table_id = module.banking_vpc.private_route_table_id
  private_subnet_a       = module.banking_vpc.private_subnet_a
  private_subnet_b       = module.banking_vpc.private_subnet_b
  ecs_security_group     = module.banking_ecs_service.ecs_security_group_id
}

module "payments_vpc_endpoints" {
  source                 = "./modules/endpoints"

  vpc_id                 = module.payments_vpc.vpc_id
  private_route_table_id = module.payments_vpc.private_route_table_id
  private_subnet_a       = module.payments_vpc.private_subnet_a
  private_subnet_b       = module.payments_vpc.private_subnet_b
  ecs_security_group     = module.payments_ecs_service.ecs_security_group_id
}

module "banking_ecs_service" {
  source                       = "./modules/ecs-service"

  ecs_cluster_name             = "banking-cluster"
  ecs_task_execution_role_name = ecsTaskExecutionRoleBanking
  ecs_log_group_name           = "/ecs/banking-tasks"
  ecs_ecs_family_name          = "banking-task-family"
  ecs_task_cpu                 = "256"
  ecs_memory                   = "512"
  ecs_container_name           = "banking-container"
  image_name                   = "${aws_ecr_repository.banking.repository_url}:latest"
  ecs_container_cpu            = 0
  container_port               = var.provider_port
  host_port                    = var.provider_port
  region                       = "us-east-2"
  app_task_sg                  = "banking-task-sg"
  vpc_id                       = module.banking_vpc.vpc_id
  endpoints_sg                 = module.endpoints.endpoints_sg_id
  app_service_name             = "banking-service"
  private_subnet_a             = module.banking_vpc.private_subnet_a
  private_subnet_b             = module.banking_vpc.private_subnet_b
  lb_target_group_arn          = aws_lb_listener.alb_listener.arn
}

module "payments_ecs_service" {
  source                 = "./modules/ecs-service"

  ecs_cluster_name             = "payments-cluster"
  ecs_task_execution_role_name = ecsTaskExecutionRolePayments
  ecs_log_group_name           = "/ecs/payments-tasks"
  ecs_ecs_family_name          = "payments-task-family"
  ecs_task_cpu                 = "256"
  ecs_memory                   = "512"
  ecs_container_name           = "payments-container"
  image_name                   = "${aws_ecr_repository.payments.repository_url}:latest"
  ecs_container_cpu            = 0
  container_port               = var.provider_port
  host_port                    = var.provider_port
  region                       = "us-east-2"
  app_task_sg                  = "payments-task-sg"
  vpc_id                       = module.payments_vpc.vpc_id
  endpoints_sg                 = module.endpoints.endpoints_sg_id
  app_service_name             = "payments-service"
  private_subnet_a             = module.payments_vpc.private_subnet_a
  private_subnet_b             = module.payments_vpc.private_subnet_b
  lb_target_group_arn          = module.private-link.lb_target_group_arn
}

module "private_link" {
  source                      = "./modules/private-link"

  nlb_name                    = "private-link-nlb"
  provider_private_subnet_a   = module.payments_vpc.private_subnet_a
  provider_private_subnet_b   = module.payments_vpc.private_subnet_b
  consumer_private_subnet_a   = module.banking_vpc.private_subnet_a
  consumer_private_subnet_b   = module.banking_vpc.private_subnet_b
  nlb_sg_name                 = "nlb-sg"
  nlb_vpc                     = module.payments_vpc.vpc_id
  consumer_vpc_cidr_block     = module.banking_vpc.cidr_block
  provider_port               = var.provider_port
  nlb_tg_name                 = "nlb-tg"
  allowed_principal_arn       = data.aws_caller_identity.current.arn
  consumer_vpc                = module.banking_vpc.vpc_id
  vpc_endpoint_sg_name        = "private-link-interface-endpoint"
  consumer_ecs_security_group = module.banking_ecs_service.ecs_security_group_id
}

module "monitoring" {
  source                      = "./modules/monitoring"

  banking_cluster_name        = module.banking_ecs_service.cluster_name
  banking_service_name        = module.banking_ecs_service.service_name
  payments_cluster_name       = module.payments_ecs_service.cluster_name
  payments_service_name       = module.payments_ecs_service.service_name
  email_address               = natoriaray@utexas.edu
  endpoint_id                 = module.private_link.private_link_interface_endpoint_id
  endpoint_service_id         = module.private_link.private_link_endpoint_service_id
  alb_arn_suffix              = aws_lb.alb.arn_suffix
  alb_target_group_arn_suffix = aws_lb_target_group.alb_tg.arn_suffix
  nlb_arn_suffix              = module.private_link.nlb_arn_suffix
  nlb_target_group_arn_suffix = module.private_link.nlb_target_group_arn_suffix
}
