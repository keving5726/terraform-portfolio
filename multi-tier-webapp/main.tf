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
  vpc       = module.networking.vpc
  sg        = module.networking.sg
}

module "autoscaling" {
  source    = "./modules/autoscaling"
  namespace = var.namespace
  vpc       = module.networking.vpc
  sg        = module.networking.sg
  db_config = module.database.db_config
}
