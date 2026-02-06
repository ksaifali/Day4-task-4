output "alb_dns_name" {
  description = "DNS name of the ALB – open http://this-value/admin in browser to access Strapi"
  value       = aws_lb.this.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.this.arn
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.this.arn
}

output "alb_zone_id" {
  description = "Canonical hosted zone ID of the ALB (useful for Route 53 alias records)"
  value       = aws_lb.this.zone_id
}
