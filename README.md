<a href="https://lacework.com"><img src="https://techally-content.s3-us-west-1.amazonaws.com/public-content/lacework_logo_full.png" width="600"></a>

# s3-notification-relay

## Example

```hcl
module "lacework_s3_notification_relay" {
  source = "github.com/alannix-lw/s3-notification-relay"

  s3_bucket_arn = "arn:aws:s3:::cloudtrail-bucket-1234567890"
  sns_topic_arn = "arn:aws:sns:us-east-1:132456789012:lacework-ct-sns-12345678"
}
```

## Providers

| Name    | Version |
| ------- | ------- |
| archive | 2.2.0   |
| aws     | 3.73.0  |
| random  | 3.1.0   |

## Resources

| Name                                                                                                                                                       | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_cloudwatch_log_group.s3_notification_relay_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)  | resource    |
| [aws_iam_role.s3_notification_relay](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                 | resource    |
| [aws_lambda_function.s3_notification_relay](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)                   | resource    |
| [aws_lambda_permission.s3_notification_relay_notify](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission)        | resource    |
| [aws_s3_bucket_notification.s3_notification_relay](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification)     | resource    |
| [random_id.uniq](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id)                                                        | resource    |
| [archive_file.s3_notification_relay_lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file)                       | data source |
| [aws_iam_policy_document.s3_notification_relay_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_notification_relay_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)    | data source |

## Inputs

| Name                                 | Description                                                                  | Type     | Default      | Required |
| ------------------------------------ | ---------------------------------------------------------------------------- | -------- | ------------ | :------: |
| prefix                               | The prefix that will be use at the beginning of every generated resource     | `string` | `"lacework"` |    no    |
| s3_bucket_arn                        | The S3 bucket ARN is required when setting use_existing_cloudtrail to true   | `string` | n/a          |   yes    |
| s3_notification_lambda_log_retention | The number of days in which to retain logs for the s3 notification lambda    | `number` | `30`         |    no    |
| s3_notification_lambda_name          | The name for the Lambda function used for the S3 notification relay          | `string` | `""`         |    no    |
| s3_notification_role_name            | The name for the IAM Role used for the S3 notification relay Lambda function | `string` | `""`         |    no    |
| sns_topic_arn                        | The SNS topic ARN                                                            | `string` | n/a          |   yes    |
