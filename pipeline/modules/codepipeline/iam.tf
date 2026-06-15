data "aws_iam_policy_document" "assume_role_codebuild" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "assume_role_codepipeline" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.tf_project.arn,
      "${aws_s3_bucket.tf_project.arn}/*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetObjectVersioning",
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.tf_project.arn,
      "${aws_s3_bucket.tf_project.arn}/*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = ["sns:Publish"]

    resources = [aws_sns_topic.tf_project.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetRepository",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive"
    ]

    resources = [aws_codecommit_repository.tf_project.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "${local.namespace}-CodeBuild"
  description        = "Terraform role for CodeBuild"
  assume_role_policy = data.aws_iam_policy_document.assume_role_codebuild.json
}

resource "aws_iam_role" "codepipeline" {
  name               = "${local.namespace}-CodePipeline"
  description        = "Terraform role for CodePipeline"
  assume_role_policy = data.aws_iam_policy_document.assume_role_codepipeline.json
}

resource "aws_iam_role_policy" "codebuild" {
  name   = "CodeBuildPolicy"
  role   = aws_iam_role.codebuild.id
  policy = data.aws_iam_policy_document.codebuild.json
}

resource "aws_iam_role_policy" "codepipeline" {
  name   = "CodePipelinePolicy"
  role   = aws_iam_role.codepipeline.id
  policy = data.aws_iam_policy_document.codepipeline.json
}

resource "aws_iam_role_policy" "deploy" {
  count  = var.deployment_policy != null ? 1 : 0
  name   = "DeployPolicy"
  role   = aws_iam_role.codebuild.name
  policy = var.deployment_policy
}
