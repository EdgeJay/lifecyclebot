terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  app_id = "${lower(var.app_name)}-${lower(var.app_env)}"
}

resource "random_id" "app_version_suffix" {
  byte_length = 4

  keepers = {
    archive_hash = "${data.archive_file.lambda_telegram_zip.output_md5}"
  }
}
