output "name" {
  value = aws_s3_bucket.my_terragrunt_bucket.bucket

}

output "arn" {
  value = aws_s3_bucket.my_terragrunt_bucket.arn

}
