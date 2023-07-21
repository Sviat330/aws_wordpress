
variable "iam_policy_name" {
  type = string
  # default = ""
}
variable "lambda_role_name" {
  type = string
  # default = "Lambda-MYSQL-RESTORE"
}
data "aws_caller_identity" "current" {}
locals {
  account_id = data.aws_caller_identity.current.id
}

data "aws_region" "current" {}


variable "basic_lambda_policy_name" {
  #default = "AWSLambdaBasicExecutionRole"
}

variable "ec2_role_name" {
  #default = "EC2-MYSQL-RESTORE"
}



data "aws_cloudwatch_event_bus" "default" {
  name = "default"
}
