

variable "vpc_requester_data_shared" { 
  default = "vpc-09ca4c03290a8e94e"
}

variable "cidr_requester_data_shared" {
   default = "10.204.0.0/19"
}


variable "vpc_acceptor_data_shared" {
  default = "vpc-0ab101372a0c6536b"   
}

variable "cidr_acceptor_data_shared" {
   default = "172.19.0.0/16"
}

variable "account_id_acceptor_data_shared" {
  default = "091782765439"
}

# Required Variables
provider "aws" {
  alias  = "acceptor_data_shared"
  profile = "cortex-shared"
  region  = var.aws_region
  # Accepter's credentials.
}


data "aws_route_tables" "acceptor_data_shared" {
  provider = aws.acceptor_data_shared
  vpc_id = var.vpc_acceptor_data_shared
}

data "aws_route_tables" "requester_data_shared" {
  vpc_id = var.vpc_requester_data_shared

}

data "aws_vpc" "accepter_data_shared" {
    provider = aws.acceptor_data_shared
    id = var.vpc_acceptor_data_shared
}

# Requester's side of the connection.
resource "aws_vpc_peering_connection" "data_shared" {
  vpc_id        =  var.vpc_requester_data_shared
  #vpc_id do solicitante (cortex-data-prod)
  peer_vpc_id   =  var.vpc_acceptor_data_shared  #vpc_id do aceitante 
  peer_owner_id =  var.account_id_acceptor_data_shared #id da conta do aceitante (integracoes)
  peer_region   =  var.aws_region
  auto_accept   = false

  tags = {
    Side = "Requester"
    Terraform   = "true"
    Name = "cortex-data-prod x cortex-shared"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "data_shared" {
  provider                  = aws.acceptor_data_shared
  vpc_peering_connection_id = aws_vpc_peering_connection.data_shared.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
    Terraform   = "true"
    Name = "cortex-data-prod x cortex-shared"
  }
}  
resource "aws_route" "requester_data_shared" {
  count = length(tolist(data.aws_route_tables.requester_data_shared.ids))
  route_table_id            = tolist(data.aws_route_tables.requester_data_shared.ids)[count.index]
  destination_cidr_block    = var.cidr_acceptor_data_shared
  vpc_peering_connection_id = aws_vpc_peering_connection.data_shared.id
}
resource "aws_route" "accepter_data_shared" {
  provider = aws.acceptor_data_shared
  count = length(tolist(data.aws_route_tables.acceptor_data_shared.ids))
  route_table_id            = tolist(data.aws_route_tables.acceptor_data_shared.ids)[count.index]
  destination_cidr_block    = var.cidr_requester_data_shared
  vpc_peering_connection_id = aws_vpc_peering_connection.data_shared.id
}  

output "rt_acepptor_data_shared" {
  value = data.aws_route_tables.acceptor_data_shared.ids
}
output "rt_requester_data_shared" {
  value = data.aws_route_tables.requester_data_shared.ids
}