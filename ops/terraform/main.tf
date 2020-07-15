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