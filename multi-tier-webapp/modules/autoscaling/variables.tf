variable "namespace" {
  type        = string
  description = "The project namespace to use for unique resource naming"
}

variable "db_config" {
  type = object({
    hostname = string
    port     = number
    database = string
    user     = string
    password = string
  })
  description = "Connection details for the database configuration"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "ssh_keypair" {
  type        = string
  description = "SSH keypair to use for EC2 instance"
  default     = null
}
