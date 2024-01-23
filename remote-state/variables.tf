variable "profile" {
  type    = string
  default = "default"
}

variable "state_bucket_name" {
  type    = string
  default = "terrafrom.state"
}

variable "state_dynamodb_table_name" {
  type    = string
  default = "terraform_state_lock"
}