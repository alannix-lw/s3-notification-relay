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

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
