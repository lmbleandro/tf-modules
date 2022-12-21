/*
 * Tags
 */
variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default = {
    Terraform  = "true"
    Team       = "SRE"
    Project    = "vpc-cortex-data-prod"
    env        = "Prod"
    Name       = "main-cortex-data-prod"
    Service    = "VPC"
    Type       = "Network"
    repository = "git@github.com:cortex-intelligence/iac-cortex-data-prod.git" # git config --get remote.origin.url
  }
}


variable "aws_profile" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "name_vpc" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "az_count" {
  type = number
}

variable "newbits" {
  type = number
}

