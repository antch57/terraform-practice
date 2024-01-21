output "lambda_1_invoke_arn" {
  value       = aws_lambda_function.lambda_1.invoke_arn
  description = "value of the lambda invoke arn"
}

output "lambda_1_arn" {
  value       = aws_lambda_function.lambda_1.arn
  description = "value of the lambda function name"
}

output "lambda_1_sg_id" {
  value       = aws_security_group.lambda_1_sg.id
  description = "value of the lambda security group"
}