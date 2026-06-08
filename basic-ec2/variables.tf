variable "region" {
  type        = string
  description = "AWS Region where the instance will be deployed"
  default     = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t4g.micro"
}

variable "instance_count" {
  type        = number
  description = "Number of EC2 instances to deploy"
  default     = 1

  validation {
    condition     = var.instance_count > 0
    error_message = "This deploy requires at least one instance"
  }
}
