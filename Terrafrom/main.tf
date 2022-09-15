terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.30.0"
    }
  }
}
provider "aws" {
  default_tags {
    tags = {
      Environment = var.company
    }
  }
}