# kinesis-firehose-ecs-logs

ECS コンテナログを Kinesis Firehose 経由で S3 に格納する為に必要な以下リソースを作成します。

- Kinesis Firehose
- Kinesis Firehose にアタッチする IAM Role
- Glue Crawler
- Glue Crawler にアタッチする IAM Role
- ECS コンテナログ格納用 Glue Catalog DB
- Kinesis Firehose が JSON から Parquet に変換する際に参照する Glue Catalog DB/Table

### Usage

```hcl
module "kinesis_firehose_ecs_logs" {
  source  = "app.terraform.io/kinesis-firehose-ecs-logs/mpg"
  version = "1.0.0"

  prefix    = "stg-dietplus"
  s3_bucket = aws_s3_bucket.logs
}
```

### variables

| name                  | description                                                             | required             | default |
| --------------------- | ----------------------------------------------------------------------- | -------------------- | ------- |
| prefix                | IAM Role, CodeBuild 等各種作成するリソース名の接頭辞 例: `prd-dietplus` |                      |
| glue_crawler_schedule | Glue Crawler 実施スケジュール                                           | `cron(00 0 1 * ? *)` |
| s3_bucket             | S3 Bucket リソース 例: `aws_s3_bucket.logs`                             |

## outputs

| output                        | value                                         | description                           |
| ----------------------------- | --------------------------------------------- | ------------------------------------- |
| firehose_role_name            | aws_iam_role.firehose.name                    | IAM Role firehose 名                  |
| firehose_role_arn             | aws_iam_role.firehose.arn                     | IAM Role firehose の ARN              |
| delivery_stream_ecs_name      | aws_kinesis_firehose_delivery_stream.ecs.name | Kinesis Firehose Delivery Stream 名   |
| delivery_stream_ecs_arn       | aws_kinesis_firehose_delivery_stream.ecs.arn  | Kinesis Firehose Delivery Stream ARN  |
| glue_catalog_db_ecs_logs_name | aws_glue_catalog_database.ecs_logs.name       | ECS コンテナログ用 Glue Catalog DB 名 |
| glue_role_arn                 | aws_iam_role.glue.arn                         | IAM Role glue の ARN                  |
| glue_role_name                | aws_iam_role.glue.name                        | IAM Role glue の Role 名              |
