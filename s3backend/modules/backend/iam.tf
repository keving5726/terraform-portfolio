data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "backend" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.backend.arn,
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = [
      "${aws_s3_bucket.backend.arn}/*",
    ]
  }
}

locals {
  principal_arns = var.principal_arns != null ? var.principal_arns : [data.aws_caller_identity.current.arn]
}

resource "aws_iam_role" "backend" {
  name        = "${local.namespace}-backend"
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

resource "aws_iam_policy" "backend" {
  name        = "${local.namespace}-policy"
  description = "Terraform policy for S3 backend"
  path        = "/"
  policy      = data.aws_iam_policy_document.backend.json
}

resource "aws_iam_role_policy_attachment" "backend" {
  role       = aws_iam_role.backend.name
  policy_arn = aws_iam_policy.backend.arn
}
