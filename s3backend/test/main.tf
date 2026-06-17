locals {
  common_tags = {
    Project     = var.namespace
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

resource "null_resource" "motto" {
  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    command = "echo ${var.message}"
  }
}
