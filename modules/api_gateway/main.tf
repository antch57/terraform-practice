resource "aws_apigatewayv2_api" "finance-tool-api" {
  name          = var.api_name
  description   = var.api_description
  protocol_type = var.api_protocol_type
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.finance-tool-api.id
  integration_type   = "AWS_PROXY"
  description        = "Lambda integration for budget tool"
  integration_uri    = var.budget_invoke_arn
}

resource "aws_apigatewayv2_route" "finance-tool-route" {
  api_id        = aws_apigatewayv2_api.finance-tool-api.id
  route_key     = "GET /budget"
  target        = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "finance-tool-stage" {
  api_id      = aws_apigatewayv2_api.finance-tool-api.id
  name        = "$default"
  description = "default stage"
  auto_deploy = true
}

# Allow API Gateway to invoke lambda
resource "aws_lambda_permission" "apigw_lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = var.budget_arn
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.finance-tool-api.execution_arn}/*/*/budget"
}