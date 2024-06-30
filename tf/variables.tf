variable "region" {
  description = "value for aws region"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "profile for execute terraform"
  type        = string
}

variable "account" {
  description = "Number of aws account"
  type        = number
}

variable "role_arn" {
  description = "Name of IAM ROLE for switch role"
  type        = string
}

variable "ssh_key_path" {
  description = "SSH key path"
  type        = string
}
