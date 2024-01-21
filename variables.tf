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
}