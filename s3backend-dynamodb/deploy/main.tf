module "s3backend_dynamodb" {
  source    = "../modules/backend"
  namespace = var.namespace
}
