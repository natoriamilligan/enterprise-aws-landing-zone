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
  ecs_container_cpu            = 0
  container_port               = 80
  host_port                    = 80
  region                       = "us-east-2"
  app_task_sg                  = "banking-task-sg"
  vpc_id                       = module.banking_vpc.vpc_id
  endpoints_sg                 = module.endpoints.endpoints_sg_id
  app_service_name             = "banking-service"
  private_subnet_a             = module.banking_vpc.private_subnet_a
  private_subnet_b             = module.banking_vpc.private_subnet_b
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
  ecs_container_cpu            = 0
  container_port               = 80
  host_port                    = 80
  region                       = "us-east-2"
  app_task_sg                  = "payments-task-sg"
  vpc_id                       = module.payments_vpc.vpc_id
  endpoints_sg                 = module.endpoints.endpoints_sg_id
  app_service_name             = "payments-service"
  private_subnet_a             = module.payments_vpc.private_subnet_a
  private_subnet_b             = module.payments_vpc.private_subnet_b
  lb_target_group_arn          = module.private-link.lb_target_group_arn
}

module "private-link" {
  source                      = "./modules/private-link"

  nlb_name                    = "private-link-nlb"
  provider_private_subnet_a   = module.payments_vpc.private_subnet_a
  provider_private_subnet_b   = module.payments_vpc.private_subnet_b
  consumer_private_subnet_a   = module.banking_vpc.private_subnet_a
  consumer_private_subnet_b   = module.banking_vpc.private_subnet_b
  nlb_sg_name                 = "nlb-sg"
  nlb_vpc                     = module.payments_vpc.vpc_id
  consumer_vpc_cidr_block     = module.banking_vpc.cidr_block
  provider_port               = 8000
  nlb_tg_name                 = "nlb-tg"
  allowed_principal_arn       = data.aws_caller_identity.current.arn
  consumer_vpc                = module.banking_vpc.vpc_id
  vpc_endpoint_sg_name        = "private-link-interface-endpoint"
  consumer_ecs_security_group = module.banking_ecs_service.ecs_security_group_id
}
