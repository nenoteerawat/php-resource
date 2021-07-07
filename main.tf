provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    encrypt = true
  }
}

module "module_usermanagement" {
  source = "./user-management"
  name   = "${var.name}_user"
  region = var.region
}

module "php_server" {
  source = "./server"
  name   = var.name
  region = var.region

  key_name_ec2_frontend = var.key_name_ec2_frontend
  login_user_ec2        = var.login_user_ec2

  db_engine_name            = var.db_engine_name
  db_engine_version         = var.db_engine_version
  db_port                   = var.db_port
  db_database_name          = var.db_database_name
  db_username               = var.db_username
  db_password               = var.db_password
  db_instance_class         = var.db_instance_class
  db_allocated_storage      = var.db_allocated_storage
  db_license_model          = var.db_license_model
  iam_instance_profile_name = module.module_usermanagement.instance_connect_name

}
