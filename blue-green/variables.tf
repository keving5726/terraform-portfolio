variable "aws_region" {
  description = "AWS Region where the instance will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "namespace" {
  description = "The project namespace to use for unique resource naming"
  type        = string
}

variable "deployment" {
  description = "The current deployment version or environment"
  type        = string

  validation {
    condition     = contains(["blue", "green"], var.deployment)
    error_message = "The deployment variable must be either 'blue' or 'green'"
  }
}
