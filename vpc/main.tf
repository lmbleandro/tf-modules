module "vpc" {
  source   = "git@github.com:cortex-intelligence/tf-modules.git//vpc?ref=tags/v0.1.41"
  vpc_cidr = var.vpc_cidr
  name_vpc = var.name_vpc
  az_count = var.az_count
  newbits  = var.newbits
  region   = var.aws_region
  tags = local.tags

}

