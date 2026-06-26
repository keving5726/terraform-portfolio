data "aws_region" "current" {}

resource "aws_resourcegroups_group" "backend" {
  name        = "${var.namespace}-group"
  description = "Terraform resource group for S3 backend"

  resource_query {
    query = <<-JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "ResourceGroup",
      "Values": ["${var.namespace}"]
    }
  ]
}
  JSON
  }
}

resource "aws_kms_key" "backend" {
  description = "Terraform KMS key for S3 backend"

  tags = {
    ResourceGroup = var.namespace
  }
}

resource "aws_s3_bucket" "backend" {
  bucket        = "${var.namespace}-backend"
  force_destroy = var.force_destroy_state

  tags = {
    ResourceGroup = var.namespace
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend" {
  bucket = aws_s3_bucket.backend.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.backend.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.backend.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.backend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "backend" {
  name         = "${var.namespace}-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    ResourceGroup = var.namespace
  }
}
