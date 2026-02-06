variable "vpc_id" {
  description = "ID of the VPC where security groups will be created"
  type        = string
}

variable "my_ip" {
  description = "Your public IP address with CIDR (e.g., 203.0.113.50/32) for SSH access"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for security group names"
  type        = string
  default     = "strapi"
}
