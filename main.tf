terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket         = "phrase-bucket"
    key            = "terraformstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state"
  }
}

resource "aws_s3_bucket" "phrase" {
  bucket = "phrase-bucket"
  versioning {
    enabled = true
  }
  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = "s3 terrraform state"
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-state"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name" = "DynamoDB Terraform State Lock Table"
  }

}


provider "aws" {
  version                 = "~> 2.0"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "personal"
  region                  = "us-east-1"
}
