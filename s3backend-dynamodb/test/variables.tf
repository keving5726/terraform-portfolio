variable "aws_region" {
  description = "AWS Region where the instance will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "message" {
  description = "The message string to be printed by the local-exec provisioner"
  type        = string
  default     = "Gotta Catch Em All"
}
