variable "env_code" {
  description = "Environment Code (dev|test|stg|prod) For development, test, staging, production."
  default     = "test"
}

variable "project_name" {
  description = "Name of the project to create"
  default     = "wordpress"
}
/*
variable "vpc_cidr_block" {
  description = "vpc_cidr_block"
  default     = module.vpc.vpc_cidr_block
}

variable "vpc_id" {
  description = "VPC id of target group "
  default     = module.vpc.vpc_id
}
*/
data "aws_key_pair" "example" {
  key_pair_id        = "key-058b0539ccd636b81"
  include_public_key = true

}
