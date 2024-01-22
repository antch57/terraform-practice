variable "region" {
  type    = string
  default = "us-east-1"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "vpc_id" {
  type = string
}

variable "vpc_endpoint_secret_manager_sg_id" {
  type = string
  description = "vpc endpoint security group id"
}

variable "lambda_1_repo_name" {
  type = string
  description = "lambda_1 ecr repo name"
}