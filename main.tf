locals {
  trimmed_bucket_arn          = trimsuffix(var.s3_bucket_arn, "/")
  bucket_arn                  = local.trimmed_bucket_arn
  split_bucket_arn            = split(":", local.trimmed_bucket_arn)
  bucket_name                 = element(local.split_bucket_arn, (length(local.split_bucket_arn) - 1))
  s3_notification_lambda_name = length(var.s3_notification_lambda_name) > 0 ? var.s3_notification_lambda_name : "${var.prefix}-s3-notification-relay-${random_id.uniq.hex}"
  s3_notification_role_name   = length(var.s3_notification_role_name) > 0 ? var.s3_notification_role_name : "${var.prefix}-s3-notification-role-${random_id.uniq.hex}"
}

resource "random_id" "uniq" {
  byte_length = 4
}

data "aws_iam_policy_document" "s3_notification_relay_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "s3_notification_relay_sns" {
  statement {
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [var.sns_topic_arn]
  }
}

resource "aws_iam_role" "s3_notification_relay" {
  name        = local.s3_notification_role_name
  description = "Allows Lambda function for call AWS services"

  assume_role_policy = data.aws_iam_policy_document.s3_notification_relay_assume.json
  inline_policy {
    name   = "${local.s3_notification_role_name}-policy"
    policy = data.aws_iam_policy_document.s3_notification_relay_sns.json
  }
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
}

resource "aws_lambda_permission" "s3_notification_relay_notify" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_notification_relay.arn
  principal     = "s3.amazonaws.com"
  source_arn    = local.bucket_arn
}

resource "aws_s3_bucket_notification" "s3_notification_relay" {
  bucket = local.bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_notification_relay.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "AWSLogs/"
  }
}

resource "aws_cloudwatch_log_group" "s3_notification_relay_lambda" {
  name              = "/aws/lambda/${local.s3_notification_lambda_name}"
  retention_in_days = var.s3_notification_lambda_log_retention
}

data "archive_file" "s3_notification_relay_lambda" {
  type        = "zip"
  output_path = "${path.module}/tmp/s3_notification_relay.zip"
  source_dir  = "${path.module}/function/src/s3-notification-relay/"
}

resource "aws_lambda_function" "s3_notification_relay" {
  function_name = local.s3_notification_lambda_name
  role          = aws_iam_role.s3_notification_relay.arn
  handler       = "main.handler"
  runtime       = "python3.9"

  environment {
    variables = {
      "SNS_TOPIC_ARN" = var.sns_topic_arn
    }
  }

  filename         = data.archive_file.s3_notification_relay_lambda.output_path
  source_code_hash = data.archive_file.s3_notification_relay_lambda.output_base64sha256
}
