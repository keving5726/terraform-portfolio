output "vpc" {
  description = "Reference to the VPC module outputs"
  value       = module.vpc
}

output "security_group_ids" {
  description = "Security group IDs for the ALB, web server, and database"
  value = {
    alb        = module.alb_sg.security_group_id
    web_server = module.web_server_sg.security_group_id
    database   = module.database_sg.security_group_id
  }
}
