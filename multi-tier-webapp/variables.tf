variable "namespace" {
  type        = string
  description = "The project namespace to use for unique resource naming"
}

variable "aws_region" {
  type        = string
  description = "AWS Region where the instance will be deployed"
}
