output "firehose_role_name" {
  description = "iam role firehose's name"
  value       = aws_iam_role.firehose.name
}

output "firehose_role_arn" {
  description = "iam role firehose's arn"
  value       = aws_iam_role.firehose.arn
}

output "delivery_stream_ecs_name" {
  description = "the name of kinesis firehose delivery stream for ecs container logs"
  value       = aws_kinesis_firehose_delivery_stream.ecs.name
}

output "delivery_stream_ecs_arn" {
  description = "the arn of kinesis firehose delivery stream for ecs container logs"
  value       = aws_kinesis_firehose_delivery_stream.ecs.arn
}

output "glue_catalog_db_ecs_logs_name" {
  description = "glue catalog ecs logs's name"
  value       = aws_glue_catalog_database.ecs_logs.name
}

output "glue_role_arn" {
  description = "iam role glue's arn"
  value       = aws_iam_role.glue.arn
}

output "glue_role_name" {
  description = "iam role glue's name"
  value       = aws_iam_role.glue.name
}
