output "nlb_sg" {
  value = aws_security_group.nlb_sg.id
}

output "private_link_interface_endpoint" {
  value = aws_security_group.private_link_interface_endpoint.id
}
