
variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "datadog_api_key" {
  type = string
}

variable "datadog_app_key" {
  type = string
}

variable "channel_name" {
  type = string
}