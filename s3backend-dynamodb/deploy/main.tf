locals {
  common_tags = {
    Project     = var.namespace
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

module "s3backend_dynamodb" {
  source    = "../modules/backend"
  namespace = var.namespace
}
