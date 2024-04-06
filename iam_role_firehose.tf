data "aws_iam_policy_document" "assume_firehose" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "firehose" {
  name               = "firehose"
  path               = "/service-role/"
  assume_role_policy = data.aws_iam_policy_document.assume_firehose.json
}

resource "aws_iam_role_policy_attachment" "firehose" {
  role       = aws_iam_role.firehose.name
  policy_arn = aws_iam_policy.firehose.arn
}

resource "aws_iam_policy" "firehose" {
  name   = "firehose"
  path   = "/service-role/"
  policy = data.aws_iam_policy_document.firehose.json
}

# see: https://docs.aws.amazon.com/firehose/latest/dev/controlling-access.html
data "aws_iam_policy_document" "firehose" {
  # see: https://docs.aws.amazon.com/firehose/latest/dev/controlling-access.html#using-iam-glue
  statement {
    actions = [
      "glue:GetTable",
      "glue:GetTableVersion",
      "glue:GetTableVersions",
    ]

    resources = [
      "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:catalog",
      aws_glue_catalog_database.schema.arn,
      aws_glue_catalog_table.ecs_log_schema.arn,
    ]
  }

  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    resources = [
      var.s3_bucket.arn,
      "${var.s3_bucket.arn}/*",
    ]
  }

  statement {
    actions = [
      "logs:PutLogEvents",
    ]
    # tfsec:ignore:aws-iam-no-policy-wildcards ロググループ内の任意のストリームにputできるように `*` での指定を許容する。
    resources = ["${aws_cloudwatch_log_group.kinesis_firehose_delivery_stream_ecs.arn}:*"]
  }
}
