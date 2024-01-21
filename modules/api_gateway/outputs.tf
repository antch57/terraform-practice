output "api_gateway_execution_arn" {
  value       = aws_apigatewayv2_api.api.execution_arn
  description = "execution arn of the API Gateway"
}

output "api_gateway_id" {
  value       = aws_apigatewayv2_api.api.id
  description = "Id of the API Gateway"
}