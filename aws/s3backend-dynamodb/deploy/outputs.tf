output "s3backend_config" {
  description = "S3 backend configuration"
  value       = module.s3backend_dynamodb.config
}
