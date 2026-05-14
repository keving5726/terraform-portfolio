variable "namespace" {
  type        = string
  description = "The project namespace to use for unique resource naming"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnets"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "database_subnets" {
  type        = list(string)
  description = "List of database subnets"
  default     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
}

variable "web_server_port" {
  type        = number
  description = "The port the web server will use for HTTP requests"
  default     = 8080
}

variable "alb_port" {
  type        = number
  description = "The port the ALB will use for HTTP requests"
  default     = 80
}

variable "allow_all_cidr" {
  type        = list(string)
  description = "CIDR block that allows all incoming and outgoing traffic"
  default     = ["0.0.0.0/0"]
}

variable "private_network_cidr" {
  type        = string
  description = "CIDR block for a private network range"
  default     = "10.0.0.0/16"
}

variable "default_egress_rule" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_blocks = string
  }))
  description = "Default egress rule allowing all outbound IPv4 traffic on all ports and protocols"
  default = [
    {
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      description = "Allows outbound traffic to any IPv4 address"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
