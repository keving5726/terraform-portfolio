variable "aws_region" {
  type        = string
  description = "AWS Region where the instance will be deployed"
  default     = "us-east-1"
}

variable "namespace" {
  type        = string
  description = "The project namespace to use for unique resource naming"
  default     = "s3backend"
}

variable "principal_arns" {
  type        = list(string)
  description = "A list of principal ARNs allowed to assume the IAM role"
  default     = null
}
