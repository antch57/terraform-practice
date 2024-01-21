output "rds_sg_id" {
  value       = aws_security_group.rds_sg.id
  description = "value of the rds security group id"
}

output "rds_hostname" {
  value       = aws_db_instance.db_instance.address
  description = "value of the rds host name"
}

output "rds_secret_manager_arn" {
  value       = aws_db_instance.db_instance.master_user_secret[0].secret_arn
  description = "value of the rds secret manager arn"
}