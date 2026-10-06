output "sg_id" {
  value = aws_security_group.app_task_sg.id
}

output "cluster_name" {
  value = aws_ecs_cluster.app_cluster.name
}

output "service_name" {
  value = aws_ecs_service.app-service.name
}

output "task_role_name" {
  value = aws_iam_role.task_execution_role.name
}
