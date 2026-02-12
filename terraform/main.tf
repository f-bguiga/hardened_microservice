resource "aws_s3_bucket" "app_data" {
  bucket = "my-hardened-app-data"
}

# This is a security "smell" we want to catch!
resource "aws_s3_bucket_public_access_block" "bad_example" {
  bucket = aws_s3_bucket.app_data.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
