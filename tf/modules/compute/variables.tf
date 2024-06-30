variable "master_count" {
  description = "Number of instaces master"
  type        = number
}

variable "worker_count" {
  description = "Number of instaces workers"
  type        = number
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "vpc_id" {
  description = "ID of vpc"
  type        = string
}

variable "sec_groups_ids" {
  description = "IDs of security groups"
  type        = list(string)
}

variable "tags" {
  description = "Tag for resources"
  type        = map(string)
  default     = {}
}