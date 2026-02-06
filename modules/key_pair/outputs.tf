output "key_name" {
  description = "The name of the AWS key pair resource (use this in EC2 launch configuration)"
  value       = aws_key_pair.this.key_name
}

output "key_fingerprint" {
  description = "The fingerprint of the public key (for verification)"
  value       = aws_key_pair.this.fingerprint
}
