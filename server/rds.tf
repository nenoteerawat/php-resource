# # ---------------------------------------------------------------------------------------------------------------------
# # CREATE THE DATABASE INSTANCE
# # ---------------------------------------------------------------------------------------------------------------------

# resource "aws_db_instance" "module_db_instance" {
#   identifier             = var.name
#   engine                 = var.db_engine_name
#   engine_version         = var.db_engine_version
#   port                   = var.db_port
#   name                   = var.db_database_name
#   username               = var.db_username
#   password               = var.db_password
#   instance_class         = var.db_instance_class
#   allocated_storage      = var.db_allocated_storage
#   skip_final_snapshot    = true
#   license_model          = var.db_license_model
#   db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
#   vpc_security_group_ids = [aws_security_group.db_instance.id]
#   # set for access db from internet
#   # publicly_accessible    = true
#   # parameter_group_name   = aws_db_parameter_group.example.id
#   # option_group_name      = aws_db_option_group.example.id

#   tags = {
#     Name = var.name
#   }
# }

# resource "aws_db_subnet_group" "db_subnet_group" {
#   name       = var.name
#   subnet_ids = ["${aws_subnet.module_subnet.id}", "${aws_subnet.module_subnet_second.id}"]

#   tags = {
#     Name = var.name
#   }
# }

# resource "aws_security_group" "db_instance" {
#   name   = var.name
#   vpc_id = aws_vpc.module_vpc.id
# }

# # resource "aws_security_group_rule" "allow_db_access" {
# #   type              = "ingress"
# #   from_port         = var.db_port
# #   to_port           = var.db_port
# #   protocol          = "tcp"
# #   security_group_id = aws_security_group.db_instance.id
# #   cidr_blocks       = ["0.0.0.0/0"]
# # }
