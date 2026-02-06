output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Private IP of the instance"
  value       = aws_instance.this.private_ip
}

output "instance_type" {
  description = "Launched instance type"
  value       = aws_instance.this.instance_type
}

output "root_volume_id" {
  description = "ID of the 20 GB root EBS volume"
  value       = aws_instance.this.root_block_device[0].volume_id
}
