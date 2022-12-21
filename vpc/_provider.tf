terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  backend "s3" {}

  required_version = ">= 1.0.7"
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

