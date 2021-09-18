# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE DATABASE INSTANCE
# ---------------------------------------------------------------------------------------------------------------------
locals {
  character_set = "utf8"
  collation     = "utf8_unicode_ci"
  time_zone     = "Asia/Bangkok"
}

resource "aws_db_instance" "module_db_instance" {
  identifier             = var.name
  engine                 = var.db_engine_name
  engine_version         = var.db_engine_version
  port                   = var.db_port
  name                   = var.db_database_name
  username               = var.db_username
  password               = var.db_password
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  skip_final_snapshot    = true
  license_model          = var.db_license_model
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_instance.id]
  # set for access db from internet
  publicly_accessible  = true
  parameter_group_name = aws_db_parameter_group.db_instance.id
  # option_group_name      = aws_db_option_group.example.id
  apply_immediately = true

  lifecycle {
    ignore_changes = [password]
  }

  tags = {
    Name = var.name
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = ["${var.db_subnet_ids[0]}", "${var.db_subnet_ids[1]}"]

  tags = {
    Name = var.name
  }
}

resource "aws_db_parameter_group" "db_instance" {
  name        = "${var.name}-db-instance"
  family      = var.db_family
  description = "setting init mysql"

  parameter {
    name         = "character_set_client"
    value        = local.character_set
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_connection"
    value        = local.character_set
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_database"
    value        = local.character_set
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_results"
    value        = local.character_set
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_server"
    value        = local.character_set
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_connection"
    value        = local.collation
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_server"
    value        = local.collation
    apply_method = "immediate"
  }

  parameter {
    name         = "time_zone"
    value        = local.time_zone
    apply_method = "immediate"
  }

  tags = {
    Name = var.name
  }
}

resource "aws_security_group" "db_instance" {
  name   = "${var.name}-db-instance"
  vpc_id = var.vpc_id

  #   ingress {
  #     description      = "Database mysql port"
  #     from_port        = var.db_port
  #     to_port          = var.db_port
  #     protocol         = "tcp"
  #     cidr_blocks      = [aws_vpc.module_vpc.cidr_block]
  #   }

  ingress {
    description      = "Database mysql port"
    from_port        = var.db_port
    to_port          = var.db_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.name}_db_secure_group"
  }
}
