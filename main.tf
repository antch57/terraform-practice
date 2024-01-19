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

module "api_gateway" {
  source          = "./modules/api_gateway"
  api_description = "This is a test API Gateway"
  api_name        = "test-api-gateway"
}

# TODO: add RDS module