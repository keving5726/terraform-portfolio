data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud_config.yaml", var.db_config)
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

module "iam_role_instance_profile" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.6.0"

  name                    = "${var.namespace}-instance-profile"
  use_name_prefix         = false
  description             = "Allows RDS to perform operations using AWS resources on your behalf and allows CloudWatch to manage EC2 instances on your behalf"
  create_instance_profile = true

  trust_policy_permissions = {
    ec2 = {
      effect = "Allow"
      actions = [
        "sts:AssumeRole"
      ]
      principals = [{
        type        = "Service"
        identifiers = ["ec2.amazonaws.com"]
      }]
    }
  }

  policies = {
    CloudWatchLogsFullAccess = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
    AmazonRDSFullAccess      = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.5.0"

  name                       = "webapp-alb"
  load_balancer_type         = "application"
  vpc_id                     = var.vpc.vpc_id
  subnets                    = var.vpc.public_subnets
  security_groups            = [var.sg.alb]
  enable_deletion_protection = false

  listeners = {
    ex_http = {
      port     = 80
      protocol = "HTTP"

      actions = [{
        fixed_response = {
          content_type = "text/plain"
          status_code  = 404
          message_body = "404: Page not found"
        }
      }]

      forward = {
        target_group_key = "ex_asg"
      }
    }
  }

  target_groups = {
    ex_asg = {
      name              = "webapp-tg"
      protocol          = "HTTP"
      port              = 8080
      target_type       = "instance"
      create_attachment = false

      health_check = {
        enabled             = true
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        matcher             = "200"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
      }
    }
  }
}

resource "aws_launch_template" "ubuntu_webapp" {
  name                   = "UbuntuWebApp"
  description            = "Ubuntu template used for the multi tier webapp"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.sg.web_server]
  key_name               = var.ssh_keypair
  user_data              = data.cloudinit_config.config.rendered

  iam_instance_profile {
    name = module.iam_role_instance_profile.name
  }
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "9.2.1"

  name            = "WebAppASG"
  use_name_prefix = false
  instance_name   = "WebApp"

  ignore_desired_capacity_changes = true

  desired_capacity          = 2
  min_size                  = 1
  max_size                  = 3
  wait_for_capacity_timeout = 0
  default_instance_warmup   = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = var.vpc.private_subnets

  create_launch_template = false
  launch_template_id     = aws_launch_template.ubuntu_webapp.id

  traffic_source_attachments = {
    ex_alb = {
      traffic_source_identifier = module.alb.target_groups["ex_asg"].arn
      traffic_source_type       = "elbv2"
    }
  }

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  tag_specifications = [{
    resource_type = "instance"
    tags          = { WhatAmI = "Instance" }
  }]
}
