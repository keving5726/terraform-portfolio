data "aws_ec2_instance_types" "free_tier" {
  filter {
    name   = "free-tier-eligible"
    values = ["true"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"]
  }
}

resource "aws_security_group" "web_server_ec2_sg" {
  name        = var.sg_name
  description = "Security group to allow traffic to the web server on port ${var.server_port}"

  tags = {
    Name = "Web Server EC2 SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ipv4" {
  security_group_id = aws_security_group.web_server_ec2_sg.id

  cidr_ipv4   = var.sg_cidr_ipv4
  from_port   = var.server_port
  ip_protocol = var.sg_ip_protocol
  to_port     = var.server_port
}

resource "aws_instance" "web_server_ec2" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_server_ec2_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Congratulations, the web server is working successfully" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "Web Server EC2 ${count.index + 1}"
  }

  lifecycle {
    precondition {
      # Check if the chosen instance type is on the AWS Free Tier list
      condition     = contains(data.aws_ec2_instance_types.free_tier.instance_types, var.instance_type)
      error_message = "The '${var.instance_type}' instance type is not elegible for Free Tier in this region"
    }
  }
}
