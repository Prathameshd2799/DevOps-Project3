resource "random_string" "bucket_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "aws_s3_bucket" "terraform_bucket" {
  bucket = "pdhalkar-fqts-backup-${random_string.bucket_suffix.result}"

  tags = {
    Name = "Terraform S3 Backend Bucket"
  }
}