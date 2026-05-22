variable "label" {
  type        = string
  description = "The label for the Blue-Green deployment"
}

variable "app_version" {
  type        = string
  description = "The app's version number"
}

variable "base" {
  type        = any
  description = "Reference to the base module outputs"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t4g.micro"
}
