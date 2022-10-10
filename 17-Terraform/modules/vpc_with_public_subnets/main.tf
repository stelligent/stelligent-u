terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.8"
    }
  }
  backend "s3" {
    bucket         = "desmond-stelligent-u-bucket"
    key            = "dev/network-infra/state/terraform.tfstate"
    encrypt        = true
    region         = "us-east-1"
    profile        = "labs"
    dynamodb_table = "terraform-up-and-running-locks"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "labs"
}

provider "archive" {}

data "aws_availability_zones" "available" {}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "tf-subnet-1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "tf-subnet-2"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id   = aws_route_table.public.id
  destination_cidr_block = var.destination_cidr
  gateway_id       = aws_internet_gateway.ig.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public.id
}


data "archive_file" "zip" {
  type        = "zip"
  source_file = "data_backup/tfplan"
  output_path = "data_backup/data_backup.zip"
  depends_on = [
    aws_vpc.main,
    aws_subnet.subnet1,
    aws_subnet.subnet2
  ]
}
