output "db_password" {
  description = "The password used to authenticate to the database"
  value       = module.database.db_config.password
  sensitive   = true
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer (ALB)"
  value       = module.autoscaling.alb_dns_name
}
