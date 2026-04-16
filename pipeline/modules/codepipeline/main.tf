resource "random_string" "rand" {
  length  = 24
  special = false
  upper   = false
}

locals {
  namespace = var.namespace != "" ? substr(join("-", [var.namespace, random_string.rand.result]), 0, 24) : random_string.rand.result

  projects = ["plan", "apply"]

  backend = templatefile("${path.module}/templates/backend.json", { config : var.s3backend_config, name : local.namespace })

  pipeline_default_env = {
    WORKING_DIRECTORY = var.working_directory
    BACKEND           = local.backend
  }

  environment = jsonencode([for k, v in merge(var.environment, local.pipeline_default_env) : { name : k, value : v, type : "PLAINTEXT" }])
}

resource "aws_kms_key" "tf_project" {
  description             = "Terraform KMS key for the AWS CodeCommit repository"
  deletion_window_in_days = 7

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
