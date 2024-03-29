variable "lambda_1_name" {
  description = "The name of the Lambda"
  type        = string
}

variable "lambda_1_description" {
  description = "The description of the Lambda"
  type        = string
}

variable "lambda_1_repo_name" {
  description = "The name of the ECR repo"
  type        = string
}

variable "vpc_id" {
  description = "the id of the vpc we are using"
  type        = string
}

variable "rds_hostname" {
  description = "the hostname of the rds instance"
  type        = string
}

variable "rds_secret_arn" {
  description = "the arn of the rds secret"
  type        = string
}