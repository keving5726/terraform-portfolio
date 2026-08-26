variable "namespace" {
  type        = string
  description = "The project namespace to use for unique resource naming"

  validation {
    condition     = length(var.namespace) <= 20 && can(regex("^[a-z0-9-]+$", var.namespace))
    error_message = "The namespace must be 20 characters or less and contain only lowercase letters, numbers, and hyphens"
  }
}

variable "location" {
  type        = string
  description = "Azure location where the virtual machine will be deployed"
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

variable "username" {
  type        = string
  description = "The username for which the Public SSH Key should be configured"
}

variable "public_key" {
  type        = string
  description = "The Public Key which should be used for authentication"
}
