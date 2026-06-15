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
}

resource "aws_s3_bucket" "tf_project" {
  bucket        = local.namespace
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.tf_project.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_sns_topic" "tf_project" {
  name = local.namespace
}

resource "aws_codecommit_repository" "tf_project" {
  repository_name = local.namespace
  description     = "Terraform sample repository"
  kms_key_id      = aws_kms_key.tf_project.arn
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
}

resource "aws_codepipeline" "codepipeline" {
  name     = local.namespace
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.tf_project.bucket
    type     = "S3"

    encryption_key {
      id   = aws_kms_key.tf_project.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName       = local.namespace
        BranchName           = "main"
        PollForSourceChanges = true
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name            = "Plan"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName          = aws_codebuild_project.tf_project[0].name
        EnvironmentVariables = local.environment
      }
    }
  }

  dynamic "stage" {
    for_each = var.auto_apply ? [] : [1]

    content {
      name = "Approval"

      action {
        name     = "Approval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"

        configuration = {
          NotificationArn = aws_sns_topic.tf_project.arn
          CustomData      = "Please review output of plan and approve"
        }
      }
    }
  }

  stage {
    name = "Apply"

    action {
      name            = "Apply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName          = aws_codebuild_project.tf_project[1].name
        EnvironmentVariables = local.environment
      }
    }
  }
}
