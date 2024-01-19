terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.32.1"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

module "lambdas" {
  source = "./modules/lambdas"
  lambda_name = "test-lambda"
  lambda_description = "This is a test lambda"
}

module "api_gateway" {
  source          = "./modules/api_gateway"
  api_description = "This is a test API Gateway"
  api_name        = "test-api-gateway"
  budget_invoke_arn = module.lambdas.lambda_invoke_arn
  budget_arn = module.lambdas.lambda_arn
}

module "rds" {
  source = "./modules/rds"
}
