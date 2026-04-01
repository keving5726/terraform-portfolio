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
