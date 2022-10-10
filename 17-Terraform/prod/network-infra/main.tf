terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "my_vpc" {
  source           = "../../modules/vpc_with_public_subnets"
  vpc_cidr         = var.vpc_cidr
  subnet1_cidr     = var.subnet1_cidr
  subnet2_cidr     = var.subnet2_cidr
  destination_cidr = var.destination_cidr
}
