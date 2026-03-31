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

module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "5.3.1"

  name            = "alb-sg"
  use_name_prefix = false
  description     = "Security group for ALB allowing inbound HTTP traffic on port ${var.alb_port}"
  vpc_id          = module.vpc.vpc_id

  ingress_cidr_blocks = var.allow_all_cidr

  auto_egress_rules       = []
  egress_with_cidr_blocks = var.default_egress_rule

  tags = {
    Name = "Application Load Balancer SG"
  }
}

module "blue_green_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name            = "blue-green-sg"
  use_name_prefix = false
  description     = "Security group for the Blue-Green deployment allowing inbound HTTP traffic on port ${var.blue_green_port}"
  vpc_id          = module.vpc.vpc_id

  ingress_cidr_blocks = ["${var.private_network_cidr}"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "http-8080-tcp"
      description              = "Allows inbound HTTP traffic on port ${var.blue_green_port} from the ALB security group"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]

  egress_with_cidr_blocks = var.default_egress_rule

  tags = {
    Name = "Blue-Green SG"
  }
}
