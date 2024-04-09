# NOTE: ECS Service のログに対して Glue Crawler でテーブル定義する親 DB
resource "aws_glue_catalog_database" "ecs_logs" {
  name = "ecs-logs"
}
