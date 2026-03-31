data "aws_region" "current" {}

resource "random_string" "rand" {
  length  = 24
  special = false
  upper   = false
}

locals {
  namespace = var.namespace != "" ? substr(join("-", [var.namespace, random_string.rand.result]), 0, 24) : random_string.rand.result
  azs       = formatlist("${data.aws_region.current.region}%s", ["a", "b"])
}

resource "aws_resourcegroups_group" "blue_green_rg" {
  name        = "${local.namespace}-rg"
  description = "Terraform resource group for the Blue-Green deployment"

  resource_query {
    query = <<-JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "ResourceGroup",
      "Values": ["${local.namespace}"]
    }
  ]
}
  JSON
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = "${local.namespace}-vpc"
  cidr = var.private_network_cidr

  azs             = local.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
