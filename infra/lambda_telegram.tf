resource "aws_lambda_function" "lambda_telegram_func" {
  filename         = data.archive_file.lambda_telegram_zip.output_path
  function_name    = local.app_id
  handler          = "app"
  source_code_hash = base64sha256(data.archive_file.lambda_telegram_zip.output_path)
  runtime          = "go1.x"
  role             = aws_iam_role.lambda_telegram_exec.arn

  environment {
    variables = {
      app_name                     = var.app_name
      app_env                      = var.app_env
      app_version                  = "${var.app_base_version}-${random_id.app_version_suffix.hex}"
      # app_version_secret           = var.app_version_secret
      # lambda_invoke_url            = var.lambda_invoke_url
      # cookie_duration              = var.cookie_duration
      # telegram_webapp_secret_key   = var.telegram_webapp_secret_key
      # menu_session_checksum_secret = var.menu_session_checksum_secret
    }
  }
}

# Assume role setup
resource "aws_iam_role" "lambda_telegram_exec" {
  name_prefix = local.app_id

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

data "aws_iam_policy_document" "lambda_telegram_ssm_policy_document" {
  statement {
    effect  = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath"
    ]

    resources = [
      "arn:aws:ssm:${var.region}:${local.account_id}:parameter/${var.app_name}/${var.app_env}/*"
    ]
  }

  statement {
    effect  = "Allow"
    actions = [
      "kms:Decrypt"
    ]

    resources = [
      "${data.aws_kms_key.ssm_key.arn}"
    ]
  }
}

resource "aws_iam_policy" "lambda_telegram_ssm_policy" {
  name   = "policy-${local.app_id}-lambda-telegram-ssm"
  policy = data.aws_iam_policy_document.lambda_telegram_ssm_policy_document.json
}

resource "aws_iam_policy_attachment" "role_attach" {
  name       = "policy-role-attach-${local.app_id}"
  roles      = [aws_iam_role.lambda_telegram_exec.id]
  count      = length(var.iam_policy_arn)
  policy_arn = element(var.iam_policy_arn, count.index)
}

resource "aws_iam_policy_attachment" "custom_policy_attach" {
  name       = "custom-policy-attach-${local.app_id}-lambda-telegram-ssm"
  roles      = [aws_iam_role.lambda_telegram_exec.id]
  policy_arn = aws_iam_policy.lambda_telegram_ssm_policy.arn
}
