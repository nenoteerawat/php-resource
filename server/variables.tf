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
variable "key_name_ec2_backend" {}

variable "iam_instance_profile_name" {}
variable "route53_zone_botman_web_id" {}
variable "route53_zone_botman_engine_id" {}
