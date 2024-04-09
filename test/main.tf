# NOTE: 最新のTerraformとAWS Providerでテストを実行する。
terraform {
  backend "local" {}
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_s3_bucket" "logs" {
  bucket = "stg-foo-logs"
}

module "kinesis_firehose_ecs_logs" {
  source = "../"

#   prefix    = "stg-foo"
  s3_bucket = aws_s3_bucket.logs
}
