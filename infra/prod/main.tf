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
}

module "rds" {
  source            = "../modules/rds"
  env_code          = "prod"
  restore_db        = false
  public_subnet_ids = module.vpc.public_subnets_id
  subnet_ids        = module.vpc.private_subnets_id
  vpc_id            = module.vpc.vpc_id
  vpc_cidr_block    = module.vpc.vpc_cidr_block
  depends_on        = [module.vpc]

}

output "load_balancer_dns_name" {
  value = aws_lb.this.dns_name
}
