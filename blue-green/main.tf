module "base" {
  source     = "./modules/base"
  namespace  = var.namespace
  deployment = var.deployment
}
