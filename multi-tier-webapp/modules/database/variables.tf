variable "namespace" {
  type        = string
  description = "The project namespace to use for unique resource naming"
}

variable "vpc" {
  type        = any
  description = "Reference to the VPC module outputs"
}

variable "sg" {
  type        = any
  description = "Security group IDs for the Application Load Balancer, web server, and database"
}

variable "db_instance_class" {
  type        = string
  description = "DB instance class"
  default     = "db.t4g.micro"
}
