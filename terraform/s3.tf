resource "aws_s3_bucket" "data_logs" {
  bucket = "hardened-project-logs-2026"
}

# SECURITY SMELL: We are explicitly allowing public access. 
# Checkov should scream at this.
resource "aws_s3_bucket_public_access_block" "insecure_access" {
  bucket = aws_s3_bucket.data_logs.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
