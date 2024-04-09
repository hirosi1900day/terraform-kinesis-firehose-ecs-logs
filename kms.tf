# awsが管理するデフォルトのkmsキーを取得します。
data "aws_kms_alias" "s3" {
  name = "alias/aws/s3"
}
