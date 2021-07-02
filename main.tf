provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    encrypt = true
  }
}

module "php_server" {
  source = "./server"
  name   = var.name
  region = var.region

  db_engine_name       = var.db_engine_name
  db_engine_version    = var.db_engine_version
  db_port              = var.db_port
  db_database_name     = var.db_database_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  db_license_model     = var.db_license_model

}
