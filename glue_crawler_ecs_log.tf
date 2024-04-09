resource "aws_glue_crawler" "ecs" {
  name          = "ecs-logs-crawler"
  database_name = aws_glue_catalog_database.ecs_logs.name
  role          = aws_iam_role.glue.arn

  # 新規フォルダのみをクロール対象とし、実行時間を減らし、コストを削減する
  recrawl_policy {
    recrawl_behavior = "CRAWL_NEW_FOLDERS_ONLY"
  }

  # NOTE: コスト節約の為、月初に実施する
  #       ログ調査時には適宜手動で実行する
  schedule = var.glue_crawler_schedule

  s3_target {
    path       = "s3://${var.s3_bucket.id}/aws-glue-ecs"
    exclusions = []
  }

  # see: https://docs.aws.amazon.com/ja_jp/glue/latest/dg/crawler-configuration.html
  schema_change_policy {
    # recrawl_behavior = "CRAWL_NEW_FOLDERS_ONLY" のデフォルトの設定で変更不可
    # 変更を無視し、 Data Catalog テーブルを更新しない
    delete_behavior = "LOG"
    update_behavior = "LOG"
  }
}
