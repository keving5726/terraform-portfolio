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

variable "web_server_port" {
  type        = number
  description = "The port the web server will use for HTTP requests"
  default     = 8080
}

variable "alb_port" {
  type        = number
  description = "The port the ALB will use for HTTP requests"
  default     = 80
}

variable "protocol" {
  type        = string
  description = "Protocol to use for routing traffic"
  default     = "HTTP"
}

variable "instance_sg_name" {
  type        = string
  description = "The name of the security group of the instances"
  default     = "web-server-sg"
}

variable "alb_sg_name" {
  type        = string
  description = "The name of the security group of the Application Load Balancer"
  default     = "alb-sg"
}

variable "ip_protocol" {
  type        = string
  description = "The IP protocol name of the security group"
  default     = "tcp"
}

variable "cidr_ipv4" {
  type        = string
  description = "The source IPv4 CIDR range of the security group"
  default     = "0.0.0.0/0"
}
