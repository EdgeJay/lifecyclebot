output "telegram_bot_api_url" {
    # value = "https://${aws_cloudfront_distribution.psgnavibot_s3_distribution.domain_name}/api"
    value = aws_api_gateway_deployment.telegram_api_deployment.invoke_url
}

output "telegram_bot_app_version" {
    value = aws_lambda_function.lambda_telegram_func.environment[0].variables.app_version
}
