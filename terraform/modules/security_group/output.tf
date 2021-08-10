
output "alb_sg_id" {
  description = "ID of the security group for application load balancer"
  value       = aws_security_group.web_lb.id
}

output "app_sg_id" {
  description = "ID of the security group for app servers"
  value       = aws_security_group.web_app.id
}

output "database_sg_id" {
  description = "ID of the security group for database (RDS)"
  value       = aws_security_group.web_db.id
}