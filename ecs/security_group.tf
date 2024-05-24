resource "aws_security_group" "autoscaling" {
  name        = "sg_node-${var.cluster_name}"
  description = "Allow public inbound traffic"
  //vpc_id      = data.terraform_remote_state.vpc.outputs.vpc
  vpc_id = var.vpc_id

  ingress {

    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["177.184.26.155/32"]
  }

  dynamic "ingress" {
    for_each = data.aws_security_group.alb
    content {
      from_port         = 0
      to_port           = 65535
      protocol          = "tcp"
      security_groups   = [ingress.value.id]
    }
  }

  dynamic "ingress" {
    for_each = var.inbound_rules
      content {
        from_port   = ingress.value.from_port
        to_port     = ingress.value.to_port
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
        security_groups = ingress.value.security_groups
      }

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

data "aws_security_group" "alb"{
  count = length(var.lista_alb_origem_acesso)
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "group-name"
    values = ["${var.lista_alb_origem_acesso[count.index]}-sg"]
  }
}
