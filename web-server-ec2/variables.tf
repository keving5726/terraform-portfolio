variable "namespace" {
  type        = string
  description = "The project namespace to use for unique resource naming"

  validation {
    condition     = length(var.namespace) <= 20 && can(regex("^[a-z0-9-]+$", var.namespace))
    error_message = "The namespace must be 20 characters or less and contain only lowercase letters, numbers, and hyphens"
  }
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

variable "instance_count" {
  type        = number
  description = "Number of EC2 instances to deploy"
  default     = 1

  validation {
    condition     = var.instance_count > 0
    error_message = "This deploy requires at least one instance"
  }
}

variable "server_port" {
  type        = number
  description = "The port the server will use for HTTP requests"
}

variable "security_group_name" {
  type        = string
  description = "The name of the security group"
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
