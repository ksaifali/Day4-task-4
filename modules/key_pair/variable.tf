variable "public_key" {
  description = "The public key material (content of your ~/.ssh/id_rsa.pub or equivalent)"
  type        = string
  sensitive   = true # Mark as sensitive to avoid displaying in logs/plan output
}

variable "key_name" {
  description = "Name of the key pair resource in AWS"
  type        = string
  default     = "strapi-key"
}

variable "name_prefix" {
  description = "Optional prefix for the key name"
  type        = string
  default     = "strapi"
}
