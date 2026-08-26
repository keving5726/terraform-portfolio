variable "label" {
  type        = string
  description = "The label for the Blue-Green deployment"
}

variable "app_version" {
  type        = string
  description = "The app's version number"
}

variable "namespace" {
  type        = string
  description = "The project namespace to use for unique resource naming"
}

variable "vpc_private_subnets" {
  type        = list(string)
  description = "A list of private subnet IDs associated with the VPC"
}

variable "alb_security_group" {
  type        = string
  description = "Security group ID for the Application Load Balancer"
}

variable "blue_green_security_group" {
  type        = string
  description = "Security group ID for the Blue-Green deployment"
}

variable "blue_target_group_arn" {
  type        = string
  description = "Blue target group ARN used to attach to Auto Scaling Group"
}

variable "green_target_group_arn" {
  type        = string
  description = "Green target group ARN used to attach to Auto Scaling Group"
}

variable "iam_role" {
  type        = string
  description = "IAM Role Instance Profile that allows EC2 instances to assume a role with CloudWatch permissions"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t4g.micro"
}
