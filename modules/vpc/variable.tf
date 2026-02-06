variable "region" {
  description = "AWS region to deploy in"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones (same length as subnets lists)"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Should we create a NAT Gateway for private subnet outbound internet?"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway (cost-effective) instead of one per AZ"
  type        = bool
  default     = true
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "strapi"
}
