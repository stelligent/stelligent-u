terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-1"
}

resource "aws_cloudformation_stack" "bucket" {
  name = "greysongundrumbucketstack"

  template_body = <<STACK
  Resources:
    ggS3Bucket:
      Type: 'AWS::S3::Bucket'
      Properties:
        BucketName: "greysongundrumbucket"
STACK
}