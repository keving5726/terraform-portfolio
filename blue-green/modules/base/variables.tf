variable "namespace" {
  description = "The project namespace to use for unique resource naming"
  type        = string
}

variable "deployment" {
  description = "The current deployment version or environment"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "blue_green_port" {
  description = "The port that the Blue-Green deployment will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "alb_port" {
  description = "The port that the ALB will use for HTTP requests"
  type        = number
  default     = 80
}
