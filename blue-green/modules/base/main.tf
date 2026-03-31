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
