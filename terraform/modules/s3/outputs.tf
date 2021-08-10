
output "access_log_bucket_id" {
  description = "The ID of the bucket for access log"
  value       = module.access_log_s3_bucket.this_s3_bucket_id
}