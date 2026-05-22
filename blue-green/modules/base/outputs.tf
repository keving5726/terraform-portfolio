output "namespace" {
  description = "The project namespace to use for unique resource naming"
  value       = local.namespace
}

output "vpc" {
  description = "Complete information from the VPC module, including the VPC ID, subnets, route tables, and other created resources"
  value       = module.vpc
}

output "security_group_ids" {
  description = "Security group IDs for the Application Load Balancer (ALB) and Blue-Green deployment"
  value = {
    alb        = module.alb_sg.security_group_id
    blue_green = module.blue_green_sg.security_group_id
  }
}

output "target_group_arns" {
  description = "Map of target group ARNs for Blue-Green deployment, used to attach to Auto Scaling Groups (ASG) or other resources"
  value       = module.alb.target_groups
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer (ALB)"
  value       = module.alb.dns_name
}

output "iam_role" {
  description = "IAM Role Instance Profile that allows EC2 instances to assume a role with CloudWatch permissions"
  value       = module.iam_role_instance_profile.name
}
