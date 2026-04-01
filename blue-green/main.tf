module "base" {
  source     = "./modules/base"
  namespace  = var.namespace
  deployment = var.deployment
}

module "blue" {
  source      = "./modules/autoscaling"
  app_version = "v1.0"
  label       = "blue"
  base        = module.base
}

module "green" {
  source      = "./modules/autoscaling"
  app_version = "v2.0"
  label       = "green"
  base        = module.base
}
