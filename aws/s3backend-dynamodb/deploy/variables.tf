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

variable "principal_arns" {
  type        = list(string)
  description = "A list of principal ARNs allowed to assume the IAM role"
  default     = null
}
