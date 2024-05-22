resource "aws_security_group" "this_sg" {
  name        = "sg_cortex"
  description = "Grupo de Seguranca Padrao VPC"
  vpc_id      = aws_vpc.this.id
  tags	      = var.tags

  ingress {
    from_port    = 22
    to_port      = 22
    protocol     = "tcp"
    cidr_blocks  = ["177.184.26.155/32"]
  }

  egress {
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }
}
