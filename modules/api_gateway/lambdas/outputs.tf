output "lambda_invoke_arn" {
  value       = aws_lambda_function.test_lambda.invoke_arn
  description = "value of the lambda invoke arn"
}

output "lambda_arn" {
  value       = aws_lambda_function.test_lambda.arn
  description = "value of the lambda function name"
}