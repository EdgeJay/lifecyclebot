data "archive_file" "lambda_telegram_zip" {
  type        = "zip"
  source_dir  = "../telegram/build/${var.app_env}/bin"
  output_path = "../telegram/build/${var.app_env}/app.zip"
}
