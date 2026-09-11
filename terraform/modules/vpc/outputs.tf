output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_route_table_id" {
  value = aws_route_table.private_route_table.id
}

output "private_subnet_a" {
  value = aws_subnet.private_a.id
}

output "private_subnet_b" {
  value = aws_subnet.private_b.id
}

output "cidr_block" {
  value = aws_vpc.vpc.cidr_block
}
