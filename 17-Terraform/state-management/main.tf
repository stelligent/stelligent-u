terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket  = "desmond-stelligent-u-bucket"
    key     = "state_management/terraform.tfstate"
    encrypt = true
    region  = "us-east-1"
    profile = "labs"
    dynamodb_table = "terraform-up-and-running-locks"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "labs"
}

resource "aws_s3_bucket" "lab17_bucket" {
  bucket = "desmond-stelligent-u-bucket"
}

resource "aws_s3_bucket_acl" "example-lab17" {
  bucket = aws_s3_bucket.lab17_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.lab17_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.lab17_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_block_access" {
    bucket = aws_s3_bucket.lab17_bucket.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}


resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform-up-and-running-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}
