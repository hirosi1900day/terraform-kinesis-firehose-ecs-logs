resource "aws_cloudwatch_log_group" "kinesis_firehose_delivery_stream_ecs" {
  name              = "/aws/kinesisfirehose/ecs"
  retention_in_days = 14
}
