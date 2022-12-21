data "aws_availability_zones" "available" {}

data "aws_availability_zone" "az" {
  count = length(data.aws_availability_zones.available.names)
  name  = data.aws_availability_zones.available.names[count.index]
}


resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = merge(
  var.tags,
  {
    "Name" = local.app_name
  },
  )
}

resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 2, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.this.id
  tags = merge(
  var.tags,
  {
    "Name" = "${local.app_name}-subnet-private-${lower(data.aws_availability_zone.az[count.index].name_suffix)}"
  },
  )
}

resource "aws_subnet" "public" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 2, var.az_count + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.this.id
  tags = merge(
  var.tags,
  {
    "Name" = "${local.app_name}-subnet-public-${lower(data.aws_availability_zone.az[count.index].name_suffix)}"
  },
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(
  var.tags,
  {
    "Name" = "${local.app_name}-igw"
  },
  )
}
resource "aws_route" "public" {
  //  route_table_id = aws_vpc.this.main_route_table_id
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.this.id

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
  var.tags,
  {
    "Name" = "${local.app_name}-rt-public"
  },
  )
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "this" {
  vpc        = true
  depends_on = [aws_internet_gateway.this]
  tags = merge(
  var.tags,
  {
    "Name" = "${local.app_name}-eip"
  },
  )

}

resource "aws_nat_gateway" "this" {

  subnet_id     = aws_subnet.public[0].id
  allocation_id = aws_eip.this.id
  tags = merge(
  var.tags,
  {
    "Name" = "${local.app_name}-ngw"
  },
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(
  var.tags,
  {
    "Name" = "${local.app_name}-rt-private"
  },
  )
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}