terraform {
  required_version = ">= 1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# Configure the AWS Provider
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs#assuming-an-iam-role
provider "aws" {
  region  = var.region
  profile = var.profile

  assume_role {
    role_arn     = "arn:aws:iam::${var.account}:role/${var.role_arn}"
    session_name = "terraform"
  }
}
