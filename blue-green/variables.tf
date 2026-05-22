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
