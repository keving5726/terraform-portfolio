output "config" {
  description = "S3 backend configuration"
  value = {
    bucket         = aws_s3_bucket.backend.bucket
    region         = data.aws_region.current.region
    dynamodb_table = aws_dynamodb_table.backend.name
    role_arn       = aws_iam_role.backend.arn
  }
}
