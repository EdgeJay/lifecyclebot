resource "aws_ssm_parameter" "telegram_bot_token" {
  name        = "/${var.app_name}/${var.app_env}/telegram_bot_token"
  description = "API token of Telegram Lifecycle Bot"
  type        = "SecureString"
  value       = var.telegram_bot_token

  tags = {
    environment = "${var.app_env}"
  }
}