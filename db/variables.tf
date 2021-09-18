variable "db_username" {}
variable "db_password" {}
variable "db_database_name" {}
variable "db_engine_name" {}
variable "db_family" { default = "mysql5.7" }
variable "db_port" {}
variable "db_major_engine_version" { default = "mysql5.7" }
variable "db_engine_version" {}
variable "db_allocated_storage" {}
variable "db_license_model" {}
variable "db_instance_class" {}
variable "db_subnet_ids" {
  type        = list(string)
  description = "List of subnet id for rds"
}
variable "vpc_id" {}
variable "name" {}
