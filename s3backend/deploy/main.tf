module "s3backend" {
  source         = "../modules/backend"
  namespace      = var.namespace
  principal_arns = var.principal_arns
}
