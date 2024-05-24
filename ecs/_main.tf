
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_version = ">= 0.15.2"
}

data "aws_caller_identity" "current" {
}





