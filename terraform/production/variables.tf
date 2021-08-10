
variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "service" {
  description = "Name to be used to tag common service name through all environments"
  default     = ""
}

variable "env" {
  description = "Environment that is used as placeholder"
  default     = ""
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overriden"
  default     = "0.0.0.0/0"
}

variable "azs" {
  description = "A list of availability zones in the region"
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  default     = []
}

variable "database_subnets" {
  description = "A list of database subnets inside the VPC"
  default     = []
}

variable "elasticache_subnets" {
  description = "A list of elasticache subnets inside the VPC"
  default     = []
}

variable "database_name" {
  description = "Name of database name"
  default     = ""
}

variable "database_user" {
  description = "Name of database user"
  default     = ""
}

variable "database_password" {
  description = "Name of database password"
  default     = ""
}

variable "rails_master_key" {
  description = "Encrypted key as rails master key"
  default     = ""
}

variable "web_ssl_cert_arn" {
  description = "ARN of ssl certs"
  default     = ""
}

variable "web_ssh_key_name" {
  description = "Name of ssh key"
  default     = ""
}

variable "web_instance_type" {
  description = "Instance type of ec2 instance"
  default     = ""
}

variable "web_instance_ami" {
  description = "Instance AMI of ec2 instance"
  default     = ""
}

variable "web_instance_count" {
  description = "Number of EC2 instances"
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

variable "aws_account_id" {
  type = string
}

variable "ebs_volume_size" {
  description = "Number of the ebs volume"
  default     = 20
}