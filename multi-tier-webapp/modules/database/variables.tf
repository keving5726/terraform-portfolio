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

variable "db_engine_version" {
  type        = string
  description = "The MySQL engine version"
  default     = "8.4.7"
}

variable "allocated_storage" {
  type        = number
  description = "The allocated storage in gigabytes"
  default     = 10
}

variable "db_name" {
  type        = string
  description = "The name of the database to create when the DB instance is created"
}

variable "db_username" {
  type        = string
  description = "Username for the master DB user"
}
