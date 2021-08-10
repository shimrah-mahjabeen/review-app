

variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "service" {
  description = "Name to be used to tag common service name through all environments"
  default     = ""
}

variable "subnet" {
  description = "A subnet name"
  default     = ""
}

variable "env" {
  description = "Environment that is used as placeholder"
  default     = ""
}

variable "azs" {
  description = "A list of availability zones in the region"
  default     = []
}

variable "security_groups" {
  description = "A list of security group ids"
  default     = []
}
