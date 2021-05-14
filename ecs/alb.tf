
resource "aws_security_group" "alb" {
  name        = "${local.app_name}-load-balancer-security-group"
  description = "Controla o acesso ao ALB"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc
  //vpc_id      = aws_vpc.this.id
  ingress {
    from_port   = var.alb_port
    to_port     = var.alb_port
    protocol    = "tcp"
    cidr_blocks = ["177.184.26.155/32"]
  }

  ingress {
    from_port   =  var.alb_port_https
    to_port     = var.alb_port_https
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_lb" "this" {
  //for_each      = data.terraform_remote_state.vpc.public_subnets
  name            = "${local.app_name}-load-balancer"
  security_groups = [aws_security_group.alb.id]
  //subnets         = join(",", data.terraform_remote_state.
  subnets = data.terraform_remote_state.vpc.outputs.public_subnets
  //aws_subnet.public.*.id


  tags = var.tags
}

resource "aws_lb_target_group" "this" {
  name        = "${var.cluster_name}-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc
  target_type = "ip"

  health_check {
    healthy_threshold   = 3
    interval            = 10
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 5
    path                = "/"
    unhealthy_threshold = 2
  }
  tags = var.tags
}

resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.alb_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.id
    #target_group_arn = var.DEFAULT_TARGET_ARN
  }
}

//resource "aws_lb_listener_rule" "this" {
//  listener_arn = aws_alb_listener.this.arn
//  priority = 100
//
//  action {
//    type = "forward"
//    target_group_arn = aws_lb_target_group.this.arn
//  }
//
//  condition {
//    path_pattern {
//      values = [
//        "/${var.path_pattern_service}/*"]
//    }
//  }
//}