

variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "vpc_id" {
  description = "ID of vpc"
  default     = ""
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = ""
}

output "redis_sg_id" {
  description = "ID of the security group for redis"
  value       = aws_security_group.web_redis.id
}