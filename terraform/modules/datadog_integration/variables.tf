
locals {
  datadog_aws_account_id = "464622532012" # AWS account ID of Datadog, it's fixed value.
}

variable "service" {
  description = "Name to be used to filter all the resources as identifier"
  default     = ""
}

variable "aws_account_id" {
  type = string
}

variable "datadog_api_key" {
  type = string
}

variable "datadog_app_key" {
  type = string
}