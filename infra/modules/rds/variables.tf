variable "restore_db" {
  description = "Controls if Db should be restored (it affects  all lambda connected resources)"
  type        = bool
  #default     = false
}



variable "env_code" {
  description = "Environment Code (dev|test|stg|prod) For development, test, staging, production."
  #default     = "test"
}
variable "db_name" {
  description = "Name of db that automatically deployed"
  #default     = "bloodbank"
}

variable "db_allocated_storage" {
  description = "Size of db"
  #default     = 20
}


variable "db_engine_type" {
  description = "Engine type of db"
  #default     = "mysql"
}
variable "db_engine_version" {
  description = "Version of choosen db"
  # default     = "8.0.32"
}

variable "db_instance_class" {
  description = "Instance class of db"
  #default     = "db.t3.micro"
}
variable "db_storage_type" {
  description = "Identifier that is used by db"
  # default     = "gp2"
}
variable "db_identifier" {
  description = "Identifier that is used by db"
  #default     = "bloodbank"
}
variable "db_username" {
  description = "Name of master user in created db"
  # default     = "bloodbank"
}
variable "pass" {
  type = string
  # default = "wasdwasd74"
}

variable "subnet_ids" {
  type = list(string)
  #  description = "Subnet that db will be deployed in "
}
variable "public_subnet_ids" {
  type = list(string)
  #  description = "Subnet that ec2 will be deployed in"

}
variable "db_port" {
  description = "Port on which db accept connection"
  #  default     = 3306
}

variable "vpc_id" {
  description = "VPC id "
}

variable "vpc_cidr_block" {
  description = "VPC cidr block"
}






