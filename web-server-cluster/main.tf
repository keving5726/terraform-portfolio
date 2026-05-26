data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "default" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}

locals {
  allowed_azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

  selected_subnet_ids = [
    for s in data.aws_subnet.default :
    s.id if contains(local.allowed_azs, s.availability_zone)
  ]

  common_tags = {
    Project     = var.namespace
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

resource "aws_security_group" "web_server_sg" {
  name        = var.instance_sg_name
  description = "Security group to allow traffic to the web server on port ${var.web_server_port}"

  tags = {
    Name = "Web Server SG"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = var.alb_sg_name
  description = "Security group to allow traffic to the ALB on port ${var.alb_port}"

  tags = {
    Name = "Application Load Balancer SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "web_server_allow_ipv4" {
  security_group_id = aws_security_group.web_server_sg.id
  description       = "Allows inbound TCP traffic on port ${var.web_server_port} to enable access to the web server"
  ip_protocol       = var.ip_protocol
  from_port         = var.web_server_port
  to_port           = var.web_server_port
  cidr_ipv4         = var.cidr_ipv4
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  description       = "Allows inbound TCP traffic on port ${var.alb_port} to enable access to the Application Load Balancer"
  ip_protocol       = var.ip_protocol
  from_port         = var.alb_port
  to_port           = var.alb_port
  cidr_ipv4         = var.cidr_ipv4
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  description       = "Allows all outbound IPv4 traffic to any destination, enabling unrestricted egress connectivity"
  ip_protocol       = "-1"
  cidr_ipv4         = var.cidr_ipv4
}

resource "aws_launch_template" "ubuntu" {
  name          = "UbuntuNobleNumbat"
  description   = "Ubuntu template used for the web server cluster"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  monitoring {
    enabled = false
  }

  network_interfaces {
    security_groups             = [aws_security_group.web_server_sg.id]
    associate_public_ip_address = false
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "Congratulations, the web server is working successfully" > index.html
              nohup busybox httpd -f -p ${var.web_server_port} &
              EOF
  )
}

resource "aws_lb" "web_server_lb" {
  name               = "web-server-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = local.selected_subnet_ids
  internal           = false
  ip_address_type    = "ipv4"

  tags = {
    Name = "Application Load Balancer"
  }

  lifecycle {
    postcondition {
      condition     = length(self.subnets) > 1
      error_message = "At least two subnets in two different Availability Zones must be specified"
    }
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_server_lb.arn
  port              = var.alb_port
  protocol          = var.protocol

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: Page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "web_server_tg" {
  name                 = "web-server-tg"
  port                 = var.web_server_port
  protocol             = var.protocol
  target_type          = "instance"
  vpc_id               = data.aws_vpc.default.id
  deregistration_delay = 30

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = var.protocol
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_server_tg.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

resource "aws_autoscaling_group" "web_server_asg" {
  name                = "WebServerASG"
  vpc_zone_identifier = local.selected_subnet_ids
  target_group_arns   = [aws_lb_target_group.web_server_tg.arn]
  health_check_type   = "ELB"
  desired_capacity    = 3
  min_size            = 2
  max_size            = 5
  force_delete        = true

  launch_template {
    id      = aws_launch_template.ubuntu.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Web Server"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.common_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
