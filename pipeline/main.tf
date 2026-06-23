locals {
  common_tags = {
    Project     = var.namespace
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

module "s3backend" {
  source         = "github.com/keving5726/terraform-practice-portfolio/s3backend/deploy?ref=develop"
  namespace      = var.namespace
  principal_arns = [module.codepipeline.deployment_role_arn]
}

module "codepipeline" {
  source            = "./modules/codepipeline"
  namespace         = var.namespace
  deployment_policy = var.deployment_policy
  s3backend_config  = module.s3backend.s3backend_config
  auto_apply        = var.auto_apply

  pipeline_environment = var.pipeline_environment
}
