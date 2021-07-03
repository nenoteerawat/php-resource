output "module_ec2_frontend_private_ip" {
  value = aws_instance.module_ec2_frontend.public_ip
}

# output "db_instance_id" {
#   value = aws_db_instance.module_db_instance.id
# }
