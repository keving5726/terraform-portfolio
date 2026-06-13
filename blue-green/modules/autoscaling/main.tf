data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"]
  }
}

locals {
  html    = templatefile("${path.module}/server/index.html", { NAME = join("-", [var.label, var.app_version]), BG_COLOR = var.label })
  startup = templatefile("${path.module}/server/startup.sh", { HTML = local.html })
}

resource "aws_launch_template" "ubuntu_blue_green" {
  name          = "Ubuntu-${var.label}"
  description   = "Ubuntu template used for the ${var.label} deployment"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  user_data     = base64encode(local.startup)

  iam_instance_profile {
    name = var.iam_role
  }

  network_interfaces {
    security_groups             = [var.blue_green_security_group]
    associate_public_ip_address = false
  }

  tags = {
    ResourceGroup = var.namespace
  }
}

resource "aws_autoscaling_group" "blue_green" {
  name                = "${var.label}-asg"
  vpc_zone_identifier = var.vpc_private_subnets
  target_group_arns   = var.label == "blue" ? [var.blue_target_group_arn] : [var.green_target_group_arn]
  health_check_type   = "EC2"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 2

  launch_template {
    id      = aws_launch_template.ubuntu_blue_green.id
    version = "$Latest"
  }

  tag {
    key                 = "ResourceGroup"
    value               = var.namespace
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = var.label
    propagate_at_launch = true
  }
}
