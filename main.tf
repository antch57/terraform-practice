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

module "rds" {
  source = "./modules/rds"
  vpc_id = var.vpc_id
}

module "lambdas" {
  source             = "./modules/lambdas"
  lambda_name        = "test-lambda"
  lambda_description = "This is a test lambda"
  vpc_id             = var.vpc_id
  rds_hostname       = module.rds.rds_hostname
}

module "api_gateway" {
  source              = "./modules/api_gateway"
  api_description     = "This is a test API Gateway"
  api_name            = "test-api-gateway"
  lambda_1_invoke_arn = module.lambdas.lambda_1_invoke_arn
  lambda_1_arn        = module.lambdas.lambda_1_arn
}

# Wire up the security groups
resource "aws_vpc_security_group_ingress_rule" "allow_lambda_1_to_rds" {
  security_group_id = module.rds.rds_sg_id

  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = module.lambdas.lambda_1_sg_id
}

resource "aws_vpc_security_group_egress_rule" "outbound_lambda_1_rds" {
  security_group_id = module.lambdas.lambda_1_sg_id

  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = module.rds.rds_sg_id
}