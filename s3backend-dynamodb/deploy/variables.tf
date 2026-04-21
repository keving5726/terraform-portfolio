variable "aws_region" {
  description = "AWS Region where the instance will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "namespace" {
  description = "The project namespace to use for unique resource naming"
  type        = string
  default     = "s3backend-dynamodb"
}
