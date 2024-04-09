variable "prefix" {
  type        = string
  default     = ""
  description = "resource name prefixes for iam role, cloudwatch loggroup, etc."
}

variable "glue_crawler_schedule" {
  type        = string
  default     = "cron(00 0 1 * ? *)"
  description = "cron for glue crawler"
}

variable "s3_bucket" {
  type        = any
  description = "ex: aws_s3_bucket.logs"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
