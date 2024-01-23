terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.32.1"
    }
  }

  backend "s3" {
    bucket         = "terraform.practice.state"
    key            = "state/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform_practice_state_lock"
  }
}

provider "aws" {
  profile = var.profile
}

module "rds" {
  source = "./modules/rds"
  vpc_id = var.vpc_id
}

module "lambdas" {
  source               = "./modules/lambdas"
  lambda_1_name        = "lambda_1"
  lambda_1_description = "This is a test lambda"
  vpc_id               = var.vpc_id
  rds_hostname         = module.rds.rds_hostname
  rds_secret_arn       = module.rds.rds_secret_manager_arn
  lambda_1_repo_name   = var.lambda_1_repo_name
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

# allow secret manager access
resource "aws_vpc_security_group_ingress_rule" "allow_lambda_1_to_secret_manager" {
  security_group_id = var.vpc_endpoint_secret_manager_sg_id

  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = module.lambdas.lambda_1_sg_id
}

resource "aws_vpc_security_group_egress_rule" "outbound_lambda_1_secret_manager" {
  security_group_id = module.lambdas.lambda_1_sg_id

  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.vpc_endpoint_secret_manager_sg_id
}