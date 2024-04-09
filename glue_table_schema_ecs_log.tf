# NOTE: ECS ログを Kinesis で JSON を Parquet に変換する際に参考にするテーブル
resource "aws_glue_catalog_table" "ecs_log_schema" {
  name          = "ecs-log-schema"
  database_name = aws_glue_catalog_database.schema.name

  table_type = "EXTERNAL_TABLE"

  partition_keys {
    name = "result"
    type = "string"
  }
  partition_keys {
    name = "year"
    type = "string"
  }
  partition_keys {
    name = "month"
    type = "string"
  }
  partition_keys {
    name = "day"
    type = "string"
  }
  partition_keys {
    name = "hour"
    type = "string"
  }

  storage_descriptor {
    columns {
      name       = "container_id"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "container_name"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "ecs_cluster"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "ecs_task_arn"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "ecs_task_definition"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "log"
      parameters = {}
      type       = "string"
    }
    columns {
      name       = "source"
      parameters = {}
      type       = "string"
    }
  }
}
