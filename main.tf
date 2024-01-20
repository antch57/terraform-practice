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

data "aws_vpc" "vpc" {
  id = ""
}

module "rds" {
  source = "./modules/rds"
  vpc_id = data.aws_vpc.vpc.id
}

module "lambdas" {
  source             = "./modules/lambdas"
  lambda_name        = "test-lambda"
  lambda_description = "This is a test lambda"
  vpc_id             = data.aws_vpc.vpc.id
  rds_hostname       = module.rds.rds_hostname
}

module "api_gateway" {
  source                   = "./modules/api_gateway"
  api_description          = "This is a test API Gateway"
  api_name                 = "test-api-gateway"
  budget_lambda_invoke_arn = module.lambdas.lambda_invoke_arn
  budget_lambda_arn        = module.lambdas.lambda_arn
  depends_on               = [module.lambdas]
}

# Wire up the security groups
resource "aws_vpc_security_group_ingress_rule" "allow_lambda_to_rds" {
  security_group_id = module.rds.rds_sg_id

  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = module.lambdas.lambda_sg_id
}

resource "aws_vpc_security_group_egress_rule" "outbound_lambda_rds" {
  security_group_id = module.lambdas.lambda_sg_id

  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = module.rds.rds_sg_id
}