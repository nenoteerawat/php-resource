output "subnet_ids" {
  value = aws_subnet.module_private_subnet.*.id
}

output "vpc_id" {
  value = aws_vpc.module_vpc.id
}
