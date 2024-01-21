resource "aws_apigatewayv2_api" "api" {
  name          = var.api_name
  description   = var.api_description
  protocol_type = var.api_protocol_type
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"
  description      = "Lambda integration for budget tool"
  integration_uri  = var.lambda_1_invoke_arn
}

resource "aws_apigatewayv2_route" "budget_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /budget"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  description = "default stage"
  auto_deploy = true
}

# TODO: make path dynamic
# Allow API Gateway to invoke lambda
resource "aws_lambda_permission" "apigw_lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_1_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*/budget"
}
