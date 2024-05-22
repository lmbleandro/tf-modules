
variable "region" {
  //default = "us-east-1"
}

variable "name_vpc" {
  //default = "main"
}

variable "vpc_cidr" {
  description = "Network CIDR for the VPC"
  //default     = "10.2.0.0/16"
}

variable "az_count" {
//  default = 4
}


variable "newbits" {
  //default = "5"
}

variable "tags" {
  //default = {
  //  "Environment" = "dev"
  //  "Team"        = "production-engineering"
  //  "Tools"       = "terraform"
  //}
}
