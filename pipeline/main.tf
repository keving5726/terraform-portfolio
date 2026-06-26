resource "random_string" "rand" {
  length  = 24
  special = false
  upper   = false
}

locals {
  namespace = substr(join("-", [var.namespace, random_string.rand.result]), 0, 24)

  common_tags = {
    Project     = local.namespace
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}


module "s3backend" {
  source         = "github.com/keving5726/terraform-practice-portfolio/s3backend/modules/backend?ref=master"
  namespace      = local.namespace
  principal_arns = [module.codepipeline.deployment_role_arn]
}

module "codepipeline" {
  source            = "./modules/codepipeline"
  namespace         = local.namespace
  deployment_policy = file(var.deployment_policy)
  s3backend_config  = module.s3backend.config
  auto_apply        = var.auto_apply

  pipeline_environment = var.pipeline_environment
}