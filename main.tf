provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    encrypt = true
  }
}

variable "name" {
  type = string
}

module "php_server" {
  source = "./server"
  name   = var.name
}
