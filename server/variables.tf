variable "region" {}
variable "name" {}
variable "ami_image" {
  type    = string
  default = "ami-018c1c51c7a13e363"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "login_user_ec2" {}
variable "key_name_ec2_frontend" {}

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
variable "iam_instance_profile_name" {}
