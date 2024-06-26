data "aws_availability_zones" "available" {}

data "aws_availability_zone" "az" {
  count = length(data.aws_availability_zones.available.names)
  name  = data.aws_availability_zones.available.names[count.index]
}
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}