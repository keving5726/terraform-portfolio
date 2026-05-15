locals {
  common_tags = {
    Project     = var.namespace
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "networking" {
  source    = "./modules/networking"
  namespace = var.namespace
}

module "database" {
  source    = "./modules/database"
  namespace = var.namespace

  db_name              = var.db_name
  db_username          = var.db_username
  db_subnet_group_name = module.networking.vpc.database_subnet_group
  db_security_group    = module.networking.security_group_ids.database
}

module "autoscaling" {
  source    = "./modules/autoscaling"
  namespace = var.namespace

  vpc_id              = module.networking.vpc.vpc_id
  vpc_public_subnets  = module.networking.vpc.public_subnets
  vpc_private_subnets = module.networking.vpc.private_subnets

  alb_security_group        = module.networking.security_group_ids.alb
  web_server_security_group = module.networking.security_group_ids.web_server

  db_config = module.database.db_config
}
