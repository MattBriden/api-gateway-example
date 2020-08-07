resource "aws_s3_bucket" "briden_lambda_bucket" {
  bucket = "briden-lambda-bucket"
  acl    = "private"

  provisioner "local-exec" {
    command = "${path.module}/../../../build/build_lambdas.sh"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.briden_lambda_bucket.bucket
}