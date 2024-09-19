terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 0.13"
}


# Create a new S3 bucket

resource "aws_s3_bucket" "my_terragrunt_bucket" {
  bucket = var.bucket_name

}

# block public access to the bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  count  = var.block_public_access ? 1 : 0
  bucket = aws_s3_bucket.my_terragrunt_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
