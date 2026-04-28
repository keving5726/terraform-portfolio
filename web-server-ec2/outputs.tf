output "public_ip" {
  description = "The public IP address of the web server"
  value       = [for instance in aws_instance.web_server_ec2 : instance.public_ip]
}
