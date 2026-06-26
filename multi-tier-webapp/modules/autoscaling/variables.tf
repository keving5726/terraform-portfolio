variable "namespace" {
  type        = string
  description = "The project namespace to use for unique resource naming"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the resources will be deployed"
}

variable "vpc_public_subnets" {
  type        = list(string)
  description = "A list of public subnet IDs associated with the VPC"
}

variable "vpc_private_subnets" {
  type        = list(string)
  description = "A list of private subnet IDs associated with the VPC"
}

variable "alb_security_group" {
  type        = string
  description = "Security group IDs for the Application Load Balancer, web server, and database"
}

variable "web_server_security_group" {
  type        = string
  description = "Security group IDs for the Application Load Balancer, web server, and database"
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
