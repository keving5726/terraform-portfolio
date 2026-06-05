provider "aws" {
  region = var.aws_region

  # Tags to apply to all AWS resources by default
  default_tags {
    tags = local.common_tags
  }
}
