
module "access_log_s3_bucket" {
  source                         = "terraform-aws-modules/s3-bucket/aws"
  version                        = "v1.17.0"
  bucket                         = var.access_log_bucket_name
  acl                            = "log-delivery-write"
  force_destroy                  = true
  attach_elb_log_delivery_policy = true
  tags = {
    Terraform   = "true"
    Service     = var.service
    DatadogFlag = var.name
  }
}

resource "aws_s3_bucket" "app" {
  bucket = var.app_bucket_name
  acl    = "public-read"
}