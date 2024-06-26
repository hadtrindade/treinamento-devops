terraform {
    backend "s3" {
        bucket = "my_bucket"
        key    = "terraform.tfstate"
        dynamodb_table = "terraform_state"
        region = "us-east-1"
    }
}