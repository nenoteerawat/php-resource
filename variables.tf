variable "region" {
  type = string
}

variable "name" {
  type = string
}

variable "db_username" {
  description = "Master username of the DB"
  type        = string
}

variable "db_password" {
  description = "Master password of the DB"
  type        = string
}

variable "db_database_name" {
  description = "Name of the database to be created"
  type        = string
}

variable "db_engine_name" {
  description = "Name of the database engine"
  type        = string
  default     = "mysql"
}

variable "db_family" {
  description = "Family of the database"
  type        = string
  default     = "mysql5.7"
}

variable "db_port" {
  description = "Port which the database should run on"
  type        = number
  default     = 3306
}

variable "db_major_engine_version" {
  description = "MAJOR.MINOR version of the DB engine"
  type        = string
  default     = "5.7"
}

variable "db_engine_version" {
  description = "Version of the database to be launched"
  default     = "5.7.21"
  type        = string
}

variable "db_allocated_storage" {
  description = "Disk space to be allocated to the DB instance"
  type        = number
  default     = 5
}

variable "db_license_model" {
  description = "License model of the DB instance"
  type        = string
  default     = "general-public-license"
}

variable "db_instance_class" {
  description = "Instance class to be used to run the database"
  type        = string
  default     = "db.t2.micro"
}
