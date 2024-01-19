variable "api_name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "api_description" {
  description = "The description of the API Gateway"
  type        = string
}

variable "api_protocol_type" {
  description = "The protocol type of the API Gateway"
  type        = string
  default     = "HTTP"
}

variable "budget_invoke_arn" {
  description = "invoke arn of the lambda integration for budget tool"
  type        = string
}

variable "budget_arn" {
  description = "arn of the lambda integration for budget tool"
  type        = string
}