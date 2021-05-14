
provider "aws" {
  region = var.region
  profile = var.profile
}

terraform {
  required_version = ">= 0.15.2"
}

data "aws_caller_identity" "current" {
}





