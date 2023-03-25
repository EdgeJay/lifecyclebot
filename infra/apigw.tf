resource "aws_api_gateway_rest_api" "telegram_api" {
  name = local.app_id
}

resource "aws_api_gateway_resource" "telegram_api_proxy" {
  path_part   = "{proxy+}"
  parent_id   = aws_api_gateway_rest_api.telegram_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.telegram_api.id
}

resource "aws_api_gateway_method" "telegram_api_proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.telegram_api.id
  resource_id   = aws_api_gateway_resource.telegram_api_proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "telegram_api_proxy_root_method" {
  rest_api_id   = aws_api_gateway_rest_api.telegram_api.id
  resource_id   = aws_api_gateway_rest_api.telegram_api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "telegram_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.telegram_api.id
  resource_id             = aws_api_gateway_method.telegram_api_proxy_method.resource_id
  http_method             = aws_api_gateway_method.telegram_api_proxy_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_telegram_func.invoke_arn
}

resource "aws_api_gateway_integration" "telegram_api_integration_root" {
  rest_api_id             = aws_api_gateway_rest_api.telegram_api.id
  resource_id             = aws_api_gateway_method.telegram_api_proxy_root_method.resource_id
  http_method             = aws_api_gateway_method.telegram_api_proxy_root_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_telegram_func.invoke_arn
}

resource "aws_api_gateway_deployment" "telegram_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.telegram_api_integration,
    aws_api_gateway_integration.telegram_api_integration_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.telegram_api.id
  stage_name  = "api"
}

resource "aws_lambda_permission" "telegram_lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_telegram_func.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.telegram_api_deployment.execution_arn}/*/*"
}
