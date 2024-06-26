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
  region = "us-east-1"
}