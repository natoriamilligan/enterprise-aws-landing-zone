output "nlb_sg" {
  value = aws_security_group.nlb_sg.id
}

output "private_link_interface_endpoint_sg" {
  value = aws_security_group.private_link_interface_endpoint.id
}

output "private_link_interface_endpoint_id" {
  value = aws_vpc_endpoint.private_link.id
}

output "private_link_endpoint_service_id" {
  value = aws_vpc_endpoint_service.nlb.id
}

output "nlb_arn_suffix" {
  value = aws_lb.nlb.arn_suffix
}

output "nlb_target_group_arn_suffix" {
  value = aws_lb.nlb.arn_suffix
}
