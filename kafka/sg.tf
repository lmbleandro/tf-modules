
resource "aws_security_group" "this" {
  name        = "sg_${var.cluster_name}-kafka"
  description = "Controla o acesso ao kafka ${var.cluster_name}"
  vpc_id      = var.vpc_id

  dynamic ingress {
    for_each = var.ingress_rules
    
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      security_groups = ingress.value.security_groups

    }
  }

  dynamic ingress {
    for_each = var.ingress_rules
  
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
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