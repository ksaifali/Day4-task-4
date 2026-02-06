# -------- Environment --------
variable "env" {
  description = "Deployment environment (dev or prod)"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

# -------- AMI --------
variable "ami_id" {
  description = "Ubuntu 22.04 AMI ID"
  type        = string
}

# -------- EC2 --------
variable "instance_types" {
  description = "Instance types per environment"
  type        = map(string)
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
}

variable "root_volume_type" {
  description = "Root EBS volume type"
  type        = string
  default     = "gp3"
}

# -------- SSH / Security --------
variable "public_key" {
  description = "Public SSH key"
  type        = string
}

variable "my_ip" {
  description = "Your public IP in CIDR format"
  type        = string
}

# -------- Networking --------
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}
