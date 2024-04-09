# NOTE: Kinesis から JSON を Parquet 変換する際に参考するテーブルの親 DB
resource "aws_glue_catalog_database" "schema" {
  name = "schema"
}
