variable "lambda_bucket" {}
variable "lambda_role" {}

data "aws_s3_bucket_object" "authorizer_lambda" {
  bucket = var.lambda_bucket
  key    = "v1/authorizer.zip"
}

resource "aws_lambda_function" "authorizer_lambda" {
  function_name = "authorizer"
  description   = "Authorizer for API Gateway"

  runtime = "python3.7"
  handler = "python/authorizer.lambda_handler"

  role = var.lambda_role

  s3_bucket = data.aws_s3_bucket_object.authorizer_lambda.bucket
  s3_key    = data.aws_s3_bucket_object.authorizer_lambda.key
}

data "aws_s3_bucket_object" "api_lambda" {
  bucket = var.lambda_bucket
  key    = "v1/api.zip"
}

resource "aws_lambda_function" "api_lambda" {
  function_name = "api"
  description   = "Lambda to execute API Gateway requests"

  runtime = "python3.7"
  handler = "python/api.lambda_handler"

  role = var.lambda_role

  s3_bucket = data.aws_s3_bucket_object.api_lambda.bucket
  s3_key    = data.aws_s3_bucket_object.api_lambda.key
}

output "api_lambda_name" {
  value = aws_lambda_function.api_lambda.function_name
}

output "api_lambda_arn" {
  value = aws_lambda_function.api_lambda.invoke_arn
}

output "authorizer_lambda_name" {
  value = aws_lambda_function.authorizer_lambda.function_name
}

output "authorizer_lambda_arn" {
  value = aws_lambda_function.authorizer_lambda.invoke_arn
}