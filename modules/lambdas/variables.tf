variable "lambda_name" {
  description = "The name of the Lambda"
  type        = string
}

variable "lambda_description" {
  description = "The description of the Lambda"
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