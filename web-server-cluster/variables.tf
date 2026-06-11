variable "namespace" {
  type        = string
  description = "The project namespace to use for unique resource naming"
  default     = "web-server-cluster"
}

variable "region" {
  type        = string
  description = "AWS Region where the instance will be deployed"
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev, staging, prod)"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment variables must be one of: dev, staging, or prod"
  }
}

variable "owner" {
  type        = string
  description = "Owner or team responsible for these resources"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "web_server_port" {
  type        = number
  description = "The port the web server will use for HTTP requests"
}

variable "alb_listener_port" {
  type        = number
  description = "The port the ALB will use for HTTP requests"
}

variable "alb_listener_protocol" {
  type        = string
  description = "Protocol to use for routing traffic"
  default     = "HTTP"
}

variable "instance_security_group_name" {
  type        = string
  description = "The name of the security group of the instances"
}

variable "alb_security_group_name" {
  type        = string
  description = "The name of the security group of the Application Load Balancer"
}

variable "security_group_protocol" {
  type        = string
  description = "The IP protocol name of the security group"
  default     = "tcp"
}

variable "security_group_cidr_ipv4" {
  type        = string
  description = "The source IPv4 CIDR range of the security group"
}
