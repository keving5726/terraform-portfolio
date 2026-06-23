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

variable "terraform_version" {
  type        = string
  description = "The version of Terraform to use for this workspace"
}

variable "working_directory" {
  type        = string
  description = "A relative path that Terraform will execute within"
}

variable "auto_apply" {
  type        = bool
  description = "Automatically apply changes when a Terraform plan runs successfully"
}

variable "pipeline_environment" {
  type        = map(string)
  description = "A map of environment variables to pass into pipeline"
}

variable "deployment_policy" {
  type        = string
  description = "An optional IAM deployment policy"
}

variable "s3backend_config" {
  type = object({
    bucket   = string
    region   = string
    role_arn = string
  })
  description = "Settings for configuring the S3 remote backend"
}
