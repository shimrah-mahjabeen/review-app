variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "service" {
  description = "Name to be used to tag common service name through all environments"
  default     = ""
}

variable "subnets" {
  description = "A list of subnets to set asg"
  default     = []
}

variable "security_groups" {
  description = "A list of security group ids for db"
  default     = []
}

variable "ssh_key_name" {
  description = "Name of ssh key"
  default     = ""
}

variable "instance_type" {
  description = "Instance type of ec2 instance"
  default     = ""
}

variable "instance_ami" {
  description = "Instance AMI of ec2 instance"
  default     = ""
}

variable "instance_count" {
  description = "Number of ec2 instances"
  default     = 1
}

variable "ebs_volume_size" {
  description = "Number of the ebs volume"
  default     = 20
}