resource "aws_s3_bucket" "briden_lambda_bucket" {
  bucket = "briden-lambda-bucket"
  acl    = "private"
}

output "bucket_name" {
  value = aws_s3_bucket.briden_lambda_bucket.bucket
}