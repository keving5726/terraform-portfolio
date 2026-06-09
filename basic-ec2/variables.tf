variable "namespace" {
  type        = string
  description = "The project namespace to use for unique resource naming"
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
  default     = "t4g.micro"
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
