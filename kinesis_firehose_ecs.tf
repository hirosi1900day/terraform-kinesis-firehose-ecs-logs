resource "aws_kinesis_firehose_delivery_stream" "ecs" {
  name = "ecs"

  destination = "extended_s3"

  extended_s3_configuration {
    role_arn = aws_iam_role.firehose.arn

    # 保存先 S3
    bucket_arn = var.s3_bucket.arn

    # ストリームがデータ暗号化に使用するキー
    kms_key_arn = data.aws_kms_alias.s3.target_key_arn

    # NOTE: JSON レコードを Parquet 形式へ変換する際に推奨されているバッファーサイズ 128MB
    # バッファーサイズ 128 MB or インターバル 900 秒に達した時に配信される。
    buffering_size     = 128 # MB
    buffering_interval = 900 # seconds

    # NOTE: AWSGlueServiceRole ポリシーは S3 Object `*aws-glue-*` を処理対象としている為、
    #       aws-glue-ecs/ としている。
    # see: https://docs.aws.amazon.com/ja_jp/glue/latest/dg/create-service-policy.html
    prefix              = "aws-glue-ecs/result=success/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
    error_output_prefix = "aws-glue-ecs/result=!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"

    s3_backup_mode = "Enabled"

    # バックアップ設定
    # see: https://docs.aws.amazon.com/ja_jp/firehose/latest/dev/create-configure.html
    # ログの欠損が生じる可能性がある為、バックアップを全て取っておきます。
    s3_backup_configuration {
      role_arn           = aws_iam_role.firehose.arn
      bucket_arn         = var.s3_bucket.arn
      prefix             = "backup/aws-glue-ecs/"
      buffering_size        = 128 # MB
      buffering_interval    = 900 # seconds
      compression_format = "GZIP"
    }

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.kinesis_firehose_delivery_stream_ecs.name
      log_stream_name = "S3Delivery"
    }

    # NOTE: JSON レコードを Parquet 形式に変換
    data_format_conversion_configuration {
      enabled = true

      input_format_configuration {
        deserializer {
          open_x_json_ser_de {}
        }
      }
      output_format_configuration {
        serializer {
          parquet_ser_de {
            compression    = "SNAPPY"
            writer_version = "V1"
          }
        }
      }

      # NOTE: JSON レコードを Parquet 形式変換する際に参照する Glue Table のスキーマ定義
      schema_configuration {
        database_name = aws_glue_catalog_database.schema.name
        table_name    = aws_glue_catalog_table.ecs_log_schema.name
        region        = data.aws_region.current.name
        role_arn      = aws_iam_role.firehose.arn
        version_id    = "LATEST"
      }
    }
  }

  # S3 保存時の暗号化
  server_side_encryption {
    enabled = true
  }
}
