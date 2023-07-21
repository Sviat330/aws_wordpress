provider "aws" {
  region = "eu-north-1"
}


module "vpc" {
  source             = "../modules/vpc"
  env_code           = "prod"
  create_nat_gateway = true
  private_cidr_blocks = [
    "10.0.12.0/24",
    "10.0.22.0/24"
  ]
  public_cidr_blocks = [
    "10.0.11.0/24",
    "10.0.21.0/24"
  ]
  vpc_cidr_block = "10.0.0.0/16"
  region         = "eu-north-1"
  project_name   = "java-login"
}

module "rds" {
  source                   = "../modules/rds"
  env_code                 = "prod"
  restore_db               = true
  public_subnet_ids        = module.vpc.public_subnets_id
  subnet_ids               = module.vpc.private_subnets_id
  vpc_id                   = module.vpc.vpc_id
  vpc_cidr_block           = module.vpc.vpc_cidr_block
  depends_on               = [module.vpc]
  db_name                  = "java-login"
  db_allocated_storage     = 20
  db_engine_type           = "mysql"
  db_engine_version        = "8.0.32"
  db_instance_class        = "db.t3.micro"
  db_storage_type          = "gp2"
  db_identifier            = "java-login"
  db_username              = "java-login"
  pass                     = "wasdwasd74"
  db_port                  = 3306
  lambda_role_name         = "Lambda-MYSQL-RESTORE"
  basic_lambda_policy_name = "AWSLambdaBasicExecutionRole"
  ec2_role_name            = "EC2-MYSQL-RESTORE"
  iam_policy_name          = ""
}

output "load_balancer_dns_name" {
  value = aws_lb.this.dns_name
}
