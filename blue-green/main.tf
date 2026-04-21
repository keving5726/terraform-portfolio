locals {
  deployment = {
    "blue" = {
      app_version = "v1.0"
    },
    "green" = {
      app_version = "v2.0"
    }
  }
}

module "base" {
  source     = "./modules/base"
  namespace  = var.namespace
  deployment = var.deployment
}

module "blue_green" {
  source      = "./modules/autoscaling"
  for_each    = local.deployment
  label       = each.key
  app_version = each.value.app_version
  base        = module.base
}
