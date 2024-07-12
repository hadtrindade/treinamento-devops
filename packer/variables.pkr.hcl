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

variable "ami_prefix" {
  description = "Prefix name of AMI"
  type        = string
  default     = "ubuntu-k8s"
}

variable "ami_owner" {
  description = "Owner for AMI"
  type        = string
}

variable "ami_filter_name" {
  description = "AMI name for filter"
  type        = string
  default     = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
}

variable "instance_type" {
  description = "Instance type for AMI"
  type        = string
}
