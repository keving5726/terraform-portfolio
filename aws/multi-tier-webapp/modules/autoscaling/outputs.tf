output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer (ALB)"
  value       = module.alb.dns_name
}
