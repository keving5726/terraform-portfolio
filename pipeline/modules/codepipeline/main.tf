resource "random_string" "rand" {
  length  = 24
  special = false
  upper   = false
}

locals {
  namespace = var.namespace != "" ? substr(join("-", [var.namespace, random_string.rand.result]), 0, 24) : random_string.rand.result

  projects = ["plan", "apply"]

  backend = templatefile("${path.module}/templates/backend.json", { config : var.s3backend_config, name : local.namespace })

  pipeline_default_env = {
    WORKING_DIRECTORY = var.working_directory
    BACKEND           = local.backend
  }

  environment = jsonencode([for k, v in merge(var.environment, local.pipeline_default_env) : { name : k, value : v, type : "PLAINTEXT" }])
}

resource "aws_kms_key" "tf_project" {
  description             = "Terraform KMS key for the AWS CodeCommit repository"
  deletion_window_in_days = 7

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "aws_s3_bucket" "tf_project" {
  bucket        = local.namespace
  force_destroy = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.tf_project.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_sns_topic" "tf_project" {
  name = local.namespace

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "aws_codecommit_repository" "tf_project" {
  repository_name = local.namespace
  description     = "Terraform sample repository"
  kms_key_id      = aws_kms_key.tf_project.arn

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "aws_codebuild_project" "tf_project" {
  count         = length(local.projects)
  name          = "${local.namespace}-${local.projects[count.index]}"
  description   = "CodeBuild project to run 'terraform ${local.projects[count.index]}'"
  service_role  = aws_iam_role.codebuild.arn
  build_timeout = 5

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:${var.terraform_version}"
    image_pull_credentials_type = "CODEBUILD"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
  }

  logs_config {
    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.tf_project.id}/codebuild-logs/${local.projects[count.index]}"
    }
  }

  source {
    type      = "NO_SOURCE"
    buildspec = file("${path.module}/templates/buildspec_${local.projects[count.index]}.yaml")
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
