data "aws_caller_identity" "current" {}

data "aws_kms_key" "ssm_key" {
  key_id = "alias/aws/ssm"
}

data "archive_file" "lambda_telegram_zip" {
  type        = "zip"
  source_dir  = "../telegram/build/${var.app_env}/bin"
  output_path = "../telegram/build/${var.app_env}/app.zip"
}
