variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04 LTS"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
}

variable "volume_type" {
  description = "Root EBS volume type"
  type        = string
  default     = "gp3"
}

variable "subnet_id" {
  description = "Private subnet ID"
  type        = string
}

variable "sg_id" {
  description = "Security Group ID"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "user_data" {
  description = "User data script"
  type        = string
  default     = ""
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "strapi"
}
