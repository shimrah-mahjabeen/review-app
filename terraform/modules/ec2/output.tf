


output "instance_ids" {
  description = "List of ids of ec2 instances"
  value       = aws_instance.app[*].id
}