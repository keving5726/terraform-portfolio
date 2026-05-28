variable "aws_region" {
  type        = string
  description = "AWS Region where the instance will be deployed"
  default     = "us-east-1"
}

variable "message" {
  type        = string
  description = "The message string to be printed by the local-exec provisioner"
  default     = "Gotta Catch Em All"
}
