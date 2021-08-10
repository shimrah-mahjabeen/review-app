locals {
  // underscore is prefereble according to official terraform bestpractice, but alb only accepts hyphen based name.
  resources_name = replace("${var.name}_web", "_", "-")
}

resource "aws_lb" "web" {
  name                       = local.resources_name
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = false
  security_groups            = var.security_groups
  subnets                    = var.subnets
  access_logs {
    bucket  = var.access_log_bucket_id
    enabled = true
  }
  tags = {
    Terraform   = "true"
    Service     = var.service
    DatadogFlag = var.name
  }
}

resource "aws_lb_target_group" "web" {
  name        = local.resources_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  health_check {
    protocol            = "HTTP"
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = 200
  }
  tags = {
    Terraform   = "true"
    Service     = var.service
    DatadogFlag = var.name
  }
}

resource "aws_lb_listener" "web_http" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "web_https" {
  load_balancer_arn = aws_lb.web.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
  lifecycle {
    ignore_changes = [
      default_action
    ]
  }
}

resource "aws_lb_target_group_attachment" "web" {
  count            = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = var.instance_ids[count.index]
  port             = 80
}