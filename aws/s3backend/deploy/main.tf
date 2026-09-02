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
  source         = "../modules/backend"
  namespace      = local.namespace
  principal_arns = var.principal_arns
}
