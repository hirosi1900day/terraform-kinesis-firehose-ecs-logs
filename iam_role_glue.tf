data "aws_iam_policy_document" "assume_glue" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "glue" {
  name               = "glue-role"
  path               = "/service-role/"
  assume_role_policy = data.aws_iam_policy_document.assume_glue.json
}

resource "aws_iam_role_policy_attachment" "glue" {
  role = aws_iam_role.glue.id
  # see: https://docs.aws.amazon.com/ja_jp/glue/latest/dg/create-service-policy.html
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}
