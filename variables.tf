variable "prefix" {
  type        = string
  default     = "lacework"
  description = "The prefix that will be use at the beginning of every generated resource"
}

variable "s3_bucket_arn" {
  type        = string
  description = "The S3 bucket ARN is required when setting use_existing_cloudtrail to true"
}

variable "s3_notification_lambda_name" {
  type        = string
  default     = ""
  description = "The name for the Lambda function used for the S3 notification relay"
}

variable "s3_notification_lambda_log_retention" {
  type        = number
  default     = 30
  description = "The number of days in which to retain logs for the s3 notification lambda"
}

variable "s3_notification_lambda_timeout" {
  type        = number
  default     = 3
  description = "The execution timeout for the Lambda function used for the S3 notification relay"
}

variable "s3_notification_log_prefix" {
  type        = string
  default     = "AWSLogs/"
  description = "The object prefix for which to create S3 notifications"
}

variable "s3_notification_role_name" {
  type        = string
  default     = ""
  description = "The name for the IAM Role used for the S3 notification relay Lambda function"
}

variable "sns_topic_arn" {
  type        = string
  description = "The SNS topic ARN"
}
