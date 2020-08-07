variable "api_lambda_name" {}
variable "api_lambda_arn" {}
variable "authorizer_lambda_name" {}
variable "authorizer_lambda_arn" {}

resource "aws_api_gateway_rest_api" "example_api" {
  name        = "ExampleAPI"
  description = "An example API Gateway"
}

resource "aws_api_gateway_resource" "root_resource" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  parent_id   = aws_api_gateway_rest_api.example_api.root_resource_id
  path_part   = "root"
}

resource "aws_api_gateway_method" "root_method" {
  rest_api_id   = aws_api_gateway_rest_api.example_api.id
  resource_id   = aws_api_gateway_resource.root_resource.id
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.example_api_authorizer.id
}

resource "aws_api_gateway_integration" "root_api_integration" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  resource_id = aws_api_gateway_resource.root_resource.id
  http_method = aws_api_gateway_method.root_method.http_method

  integration_http_method = "ANY"
  type                    = "AWS_PROXY"
  uri                     = var.api_lambda_arn
}

resource "aws_api_gateway_authorizer" "example_api_authorizer" {
  name                   = "ExampleAPIAuthorizer"
  rest_api_id            = aws_api_gateway_rest_api.example_api.id
  authorizer_uri         = var.authorizer_lambda_arn
  type                   = "REQUEST"
  identity_source        = "method.request.header.Authorization"
}

resource "aws_lambda_permission" "allow_api_lambda" {
  function_name = var.api_lambda_name
  statement_id  = "AllowExampleAPIInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.example_api.execution_arn}/*/*/*"

  depends_on = [
    aws_api_gateway_rest_api.example_api
  ]
}

resource "aws_lambda_permission" "allow_authorizer_lambda" {
  function_name = var.authorizer_lambda_name
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.example_api.execution_arn}/authorizers/*"

  depends_on = [
    aws_api_gateway_rest_api.example_api
  ]
}

resource "aws_api_gateway_deployment" "example_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.root_api_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.example_api.id

  # Any changes to these resources will trigger a redeployment of the API Gateway
  # https://www.terraform.io/docs/providers/aws/r/api_gateway_deployment.html
  triggers = {
    redeployment = sha1(join(",", list(
      jsonencode(aws_api_gateway_integration.root_api_integration),
      jsonencode(aws_api_gateway_authorizer.example_api_authorizer)
    )))
  }

  lifecycle {
    create_before_destroy = true
  }
}
