

variable "vpc_requester" { 
  default = "vpc-09ca4c03290a8e94e"
}

variable "vpc_acceptor" {
  default = "vpc-07330e0461ef153f8"   
}

variable "account_id_acceptor" {
  default = "547854491677"
  
}
 variable "cidr_requester" {
   default = "10.90.0.0/16"
 }

 variable "cidr_acceptor" {
   default = "10.204.0.0/19"
   
 }

# Required Variables
provider "aws" {
  alias  = "acceptor"
  profile = "cortex-integracoes"
  region  = var.aws_region
  # Accepter's credentials.
}


data "aws_route_tables" "acceptor" {
  provider = aws.acceptor
  vpc_id = var.vpc_acceptor
}

data "aws_route_tables" "requester" {
  vpc_id = var.vpc_requester
}

data "aws_vpc" "accepter" {
    provider = aws.acceptor
    id = var.vpc_acceptor
}

# Requester's side of the connection.
resource "aws_vpc_peering_connection" "peer" {
  vpc_id        =  var.vpc_requester  #vpc_id do solicitante (cortex-data-prod)
  peer_vpc_id   =  var.vpc_acceptor  #vpc_id do aceitante 
  peer_owner_id =  var.account_id_acceptor #id da conta do aceitante (integracoes)
  peer_region   =  var.aws_region
  auto_accept   = false

  tags = {
    Side = "Requester"
    Terraform   = "true"
    Name = "cortex-data-prod x cortex-integrcoes"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.acceptor
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
    Terraform   = "true"
    Name = "cortex-data-prod x cortex-integrcoes"
  }
}  
resource "aws_route" "requester" {
  count = length(tolist(data.aws_route_tables.requester.ids))
  route_table_id            = tolist(data.aws_route_tables.requester.ids)[count.index]
  destination_cidr_block    = var.cidr_acceptor
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
resource "aws_route" "accepter" {
  provider = aws.acceptor
  count = length(tolist(data.aws_route_tables.acceptor.ids))
  route_table_id            = tolist(data.aws_route_tables.acceptor.ids)[count.index]
  destination_cidr_block    = var.cidr_requester
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}  

output "rt_acepptor" {
  value = data.aws_route_tables.acceptor.ids
}
output "rt_requester" {
  value = data.aws_route_tables.requester.ids
}