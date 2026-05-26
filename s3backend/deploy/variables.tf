variable "aws_region" {
  type        = string
  description = "AWS Region where the instance will be deployed"
  default     = "us-east-1"
}

variable "namespace" {
  type        = string
  description = "The project namespace to use for unique resource naming"
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

variable "principal_arns" {
  type        = list(string)
  description = "A list of principal ARNs allowed to assume the IAM role"
  default     = null
}
