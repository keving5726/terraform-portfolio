data "aws_ec2_instance_types" "free_tier" {
  filter {
    name   = "free-tier-eligible"
    values = ["true"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-arm64"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "ena-support"
    values = [true]
  }

  filter {
    name   = "root-device-name"
    values = ["/dev/xvda"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "hypervisor"
    values = ["xen"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "basic_ec2" {
  count         = var.instance_count
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  tags = {
    Name = "Basic EC2 ${count.index + 1}"
  }

  lifecycle {
    precondition {
      # Check if the chosen instance type is on the AWS Free Tier list
      condition     = contains(data.aws_ec2_instance_types.free_tier.instance_types, var.instance_type)
      error_message = "The '${var.instance_type}' instance type is not elegible for Free Tier in this region"
    }
  }
}
