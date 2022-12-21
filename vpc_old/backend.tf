terraform {
  backend "s3" {
    bucket = "terraform-production-engineering"
    key    = "vpc-production-engineering/vpc-engenharia.tfstate"
    region = "us-east-1"
  }
}