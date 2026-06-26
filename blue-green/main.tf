locals {
  common_tags = {
    Project     = var.namespace
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }

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

  namespace           = var.namespace
  vpc_private_subnets = module.base.vpc.private_subnets
  iam_role            = module.base.iam_role

  alb_security_group        = module.base.security_group_ids.alb
  blue_green_security_group = module.base.security_group_ids.blue_green

  blue_target_group_arn  = module.base.target_group_arns.ex_blue.arn
  green_target_group_arn = module.base.target_group_arns.ex_green.arn
}
