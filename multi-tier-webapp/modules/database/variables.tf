variable "namespace" {
  type        = string
  description = "The project namespace to use for unique resource naming"
}

variable "db_instance_class" {
  type        = string
  description = "DB instance class"
  default     = "db.t4g.micro"

  validation {
    condition     = can(regex("^db\\.", var.db_instance_class))
    error_message = "The 'db_instance_class' must be a valid RDS instance type starting with 'db.'"
  }
}
