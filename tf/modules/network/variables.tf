variable "vpc_cidr_block" {
  description = "CIDR block for vpc"
  type        = string
}

variable "subnet_count" {
  description = "Number of subnets"
  type        = number
  default     = 3

  validation {
    condition     = var.subnet_count <= 3
    error_message = "Maximum value is 3"
  }
}

variable "nat_instance" {
  description = "Enable nat instance for subnets privates"
  type        = bool
  default     = false
}
