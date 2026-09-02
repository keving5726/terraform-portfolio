provider "aws" {
  region = var.region

  # Tags to apply to all AWS resources by default
  default_tags {
    tags = local.common_tags
  }
}
