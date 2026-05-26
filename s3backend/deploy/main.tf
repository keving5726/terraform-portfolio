locals {
  common_tags = {
    Project     = var.namespace
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

module "s3backend" {
  source         = "../modules/backend"
  namespace      = var.namespace
  principal_arns = var.principal_arns
}
