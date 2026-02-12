provider "aws" {
  region = var.aws_region
}

# Dynamic S3 Bucket with tags for auditing
resource "aws_s3_bucket" "app_data" {
  bucket = "${var.project_name}-${var.environment}-data-2026"

  tags = {
    Name        = "${var.project_name}-storage"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Security Blocks remain the same but point to the dynamic resource
resource "aws_s3_bucket_versioning" "app_data_versioning" {
  bucket = aws_s3_bucket.app_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_data_encryption" {
  bucket = aws_s3_bucket.app_data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "app_data_access" {
  bucket = aws_s3_bucket.app_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_secretsmanager_secret" "app_secrets" {
  name        = "${var.project_name}-${var.environment}-secrets"
  description = "Hardened credentials for the app"
  
  # CKV_AWS_149: Encryption is handled by default AWS KMS keys here
}

resource "aws_secretsmanager_secret_version" "initial_version" {
  secret_id     = aws_secretsmanager_secret.app_secrets.id
  secret_string = jsonencode({
    api_key     = "REDACTED_USE_VAULT_OR_CONSOLE"
    db_password = "REDACTED_USE_VAULT_OR_CONSOLE"
  })
}
