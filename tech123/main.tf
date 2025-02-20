module "vpc" {
  source               = "./modules/vpc"
  project_name         = var.project_name
  netw_cidr            = var.netw_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  db_subnets_cidr      = var.db_subnets_cidr
  availability_zones   = var.availability_zones
}

module "Security_groups" {
  source = "./modules/Security_groups"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  my_ip = var.my_ip
}
