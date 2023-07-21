locals {
  def_tag                  = "${var.env_code}-${var.project_name}"
  public_subnet_id         = [module.vpc.public_subnets_id[0], module.vpc.public_subnets_id[1]]
  front_private_subnets_id = [module.vpc.private_subnets_id[0], module.vpc.private_subnets_id[1]]
  vpc_cidr_block           = module.vpc.vpc_cidr_block
  vpc_id                   = module.vpc.vpc_id
}
