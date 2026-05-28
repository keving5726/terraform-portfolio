variable "aws_region" {
  type        = string
  description = "AWS Region where the instance will be deployed"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t4g.micro"
}
