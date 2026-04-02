data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "tf_backend" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.tf_backend.arn,
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = [
      "${aws_s3_bucket.tf_backend.arn}/*",
    ]
  }

  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]

    resources = [
      aws_dynamodb_table.tf_backend.arn,
    ]
  }
}

locals {
  principal_arns = var.principal_arns != null ? var.principal_arns : [data.aws_caller_identity.current.arn]
}

resource "aws_iam_role" "tf_backend" {
  name        = "${local.namespace}-tf-backend"
  description = "Terraform role for S3 backend"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = local.principal_arns
        }
      }
    ]
  })

  tags = {
    ResourceGroup = local.namespace
  }
}

resource "aws_iam_policy" "tf_backend" {
  name        = "${local.namespace}-tf-policy"
  description = "Terraform policy for S3 backend"
  path        = "/"
  policy      = data.aws_iam_policy_document.tf_backend.json
}

resource "aws_iam_role_policy_attachment" "tf_backend" {
  role       = aws_iam_role.tf_backend.name
  policy_arn = aws_iam_policy.tf_backend.arn
}
