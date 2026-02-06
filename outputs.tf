output "alb_dns_name" {
  description = "Open this in browser → http://<this>/admin (first time setup Strapi admin)"
  value       = module.alb.alb_dns_name
}

output "ec2_private_ip" {
  value = module.ec2.private_ip
}

output "nat_public_ip" {
  value = aws_eip.nat.public_ip
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnets" {
  value = [for s in aws_subnet.private : s.id]
}

output "key_name" {
  value = module.key_pair.key_name
}