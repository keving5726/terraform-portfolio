variable "aws_region" {
  type        = string
  description = "AWS Region where the instance will be deployed"
  default     = "us-east-1"
}

variable "namespace" {
  type        = string
  description = "The project namespace to use for unique resource naming"
}

variable "deployment" {
  type        = string
  description = "The current deployment version or environment"

  validation {
    condition     = contains(["blue", "green"], var.deployment)
    error_message = "The deployment variable must be either 'blue' or 'green'"
  }
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
