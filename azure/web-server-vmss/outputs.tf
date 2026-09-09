output "load_balancer_public_ip_address" {
  type        = string
  description = "The public IP address of the Load Balancer"
  value       = azurerm_public_ip.main.ip_address
}
