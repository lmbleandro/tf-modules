
variable "region" {
  default = "us-east-1"
}

variable "name_vpc" {}

variable "cidr" {}

variable "backend" {
  default = "terraform-production-engineering"
}


variable "az_count" {
  default = 2
}

variable "tags" {
  type    = "map"
  #default = {}
}

//variable "tags" {
//  default = {
//    "Environment" = "dev"
//    "Team"        = "production-engineering"
//    "Tools"       = "terraform"
//  }
//}
