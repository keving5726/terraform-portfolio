output "deployment_role_arn" {
  description = "Terraform role to run the deploy"
  value       = aws_iam_role.codebuild.arn
}
