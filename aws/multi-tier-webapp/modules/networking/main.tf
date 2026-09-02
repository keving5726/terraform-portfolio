data "aws_region" "current" {}

locals {
  azs = formatlist("${data.aws_region.current.region}%s", ["a", "b", "c"])
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"

  name = "${var.namespace}-vpc"
  cidr = var.private_network_cidr

  azs              = local.azs
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true
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

module "web_server_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name            = "web-server-sg"
  use_name_prefix = false
  description     = "Security group for web servers allowing inbound HTTP traffic on port ${var.web_server_port} and SSH access on port 22"
  vpc_id          = module.vpc.vpc_id

  ingress_cidr_blocks = ["${var.private_network_cidr}"]
  ingress_rules       = ["ssh-tcp"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "http-8080-tcp"
      description              = "Allows inbound HTTP traffic on port ${var.web_server_port} from the ALB security group"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]

  egress_with_cidr_blocks = var.default_egress_rule

  tags = {
    Name = "Web Server SG"
  }
}

module "database_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name            = "database-sg"
  use_name_prefix = false
  description     = "Security group for RDS allowing inbound MySQL access"
  vpc_id          = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      description              = "Allows inbound MySQL access from web server security group"
      source_security_group_id = module.web_server_sg.security_group_id
    }
  ]

  egress_with_cidr_blocks = var.default_egress_rule

  tags = {
    Name = "Database SG"
  }
}
