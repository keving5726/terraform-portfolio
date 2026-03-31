variable "label" {
  description = "The label for the Blue-Green deployment"
  type        = string
}

variable "app_version" {
  description = "The app's version number"
  type        = string
}

variable "base" {
  description = "Reference to the base module outputs"
  type        = any
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t4g.micro"
}
