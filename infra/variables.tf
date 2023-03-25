variable "region" {
  description = "AWS region"
}

variable "prefix" {
  description = "Environment prefix for resource names"
}

variable "app_name" {
  description = "Application name"
}

variable "app_env" {
  description = "Application environment"
}

variable "app_base_version" {
  description = "Application base version"
}

# Attach role to Managed Policy
variable "iam_policy_arn" {
  description = "IAM Policy to be attached to role"
  type        = list(string)

  default = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}
