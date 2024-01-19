output "api_gateway_execution_arn" {
  value       = aws_apigatewayv2_api.finance-tool-api.execution_arn
  description = "execution arn of the API Gateway"
}

output "api_gateway_id" {
  value       = aws_apigatewayv2_api.finance-tool-api.id
  description = "Id of the API Gateway"
}