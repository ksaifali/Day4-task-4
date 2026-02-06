variable "vpc_id" {
  description = "ID of the VPC where the ALB will be created"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs (at least 2 for high availability)"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security Group ID for the ALB (allows inbound HTTP/HTTPS)"
  type        = string
}

variable "target_instance" {
  description = "ID of the EC2 instance to register with the target group"
  type        = string
}

variable "target_port" {
  description = "Port on the target (EC2) where the application listens"
  type        = number
  default     = 1337
}

variable "health_check_path" {
  description = "Path for health checks (Strapi root or /admin works)"
  type        = string
  default     = "/"
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "strapi"
}
