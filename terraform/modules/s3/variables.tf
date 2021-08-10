variable "access_log_bucket_name" {
  description = "Name to be used on s3 bucket name for access log"
  default     = ""
}

variable "app_bucket_name" {
  description = "Name to be used on s3 bucket name for app"
  default     = ""
}

variable "service" {
  description = "Name to be used to tag common service name through all environments"
  default     = ""
}

variable "name" {
  description = "Name to be used to tag name"
  default     = ""
}