variable "aws_region" {
  type        = string
  description = "AWS Region where the instance will be deployed"
  default     = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t4g.micro"
}

variable "server_port" {
  type        = number
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

variable "sg_name" {
  type        = string
  description = "The name of the security group"
  default     = "web-server-ec2-sg"
}

variable "sg_ip_protocol" {
  type        = string
  description = "The IP protocol name of the security group"
  default     = "tcp"
}

variable "sg_cidr_ipv4" {
  type        = string
  description = "The source IPv4 CIDR range of the security group"
  default     = "0.0.0.0/0"
}
