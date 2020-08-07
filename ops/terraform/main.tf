module "iam" {
  source = "./modules/iam"
}

module "s3" {
  source = "./modules/s3"
}

module "lambdas" {
  source = "./modules/lambdas"

  lambda_bucket = module.s3.bucket_name
  lambda_role   = module.iam.lambda_role
}

module "apigateway" {
  source = "./modules/apigateway"

  api_lambda_name        = module.lambdas.api_lambda_name
  api_lambda_arn         = module.lambdas.api_lambda_arn
  authorizer_lambda_name = module.lambdas.authorizer_lambda_name
  authorizer_lambda_arn  = module.lambdas.authorizer_lambda_arn
}