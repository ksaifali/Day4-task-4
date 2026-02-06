output "alb_sg_id" {
  description = "Security Group ID for the Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "ec2_sg_id" {
  description = "Security Group ID for the private EC2 instance"
  value       = aws_security_group.ec2.id
}

output "alb_sg_name" {
  description = "Name of the ALB security group"
  value       = aws_security_group.alb.name
}

output "ec2_sg_name" {
  description = "Name of the EC2 security group"
  value       = aws_security_group.ec2.name
}
