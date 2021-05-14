
resource "aws_security_group" "autoscaling" {
  name        = "autoscaling"
  description = "Allow public inbound traffic"
  vpc_id      = var.vpc_id
  //data.terraform_remote_state.vpc.outputs.vpc

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["177.184.26.155/32"]
  }


  ingress {

    from_port       = 9000
    to_port         = 9000
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb.id}"]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_launch_configuration" "ecs-launch" {
  name_prefix   = "autoscaling-launch"
  image_id      = data.aws_ami.amzn.id
  instance_type = var.instance_type
  #key_name             = var.key_pair
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_role.id
  associate_public_ip_address = true
  #spot_price    = "0.001"

  security_groups = [aws_security_group.autoscaling.id]

  user_data = "#!/bin/bash\nsysctl -w vm.max_map_count=524288\nsysctl -w fs.file-max=131072\nmkdir /opt/sonarqube/\necho 'ECS_CLUSTER=${var.cluster_name}'> /etc/ecs/ecs.config\nstart ecs"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "asg_group" {
  name                      = "${local.app_name}-scale_group"
  vpc_zone_identifier       = data.terraform_remote_state.vpc.outputs.private_subnets
  launch_configuration      = aws_launch_configuration.ecs-launch.name
  max_size                  = var.desired_count_asg_max
  min_size                  = var.desired_count_asg_mim
  health_check_grace_period = 60
  #target_group_arns        = [aws_lb_target_group.this.arn]

  tags = [
    {
      key                 = "Environment"
      value               = "dev"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "node-${local.app_name}-ec2"
      propagate_at_launch = true
    },
    {
      key                 = "Team"
      value               = "production-engineering"
      propagate_at_launch = true
    },
    {
      key                 = "Tools"
      value               = "terraform"
      propagate_at_launch = true
    },
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "UP" {
  name                   = "${aws_ecs_cluster.this.name}-Scale-Up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.asg_group.name
  policy_type            = "SimpleScaling"

}

resource "aws_autoscaling_policy" "Dow" {
  name                   = "${aws_ecs_cluster.this.name}-Scale-Down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.asg_group.name
  policy_type            = "SimpleScaling"
}

resource "aws_autoscaling_schedule" "ecs_stop" {
  //count                  = var.enable_schedule ? 1 : 0
  scheduled_action_name  = "ecs-${local.app_name}-stop"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  autoscaling_group_name = aws_autoscaling_group.asg_group.name
  recurrence             = var.schedule_cron_stop
}

resource "aws_autoscaling_schedule" "ecs_start" {
  //count                  = var.enable_schedule ? 1 : 0
  scheduled_action_name  = "ecs-${local.app_name}-start"
  min_size               = var.desired_count_asg_mim
  max_size               = var.desired_count_asg_max
  desired_capacity       = var.desired_count_asg_mim
  autoscaling_group_name = aws_autoscaling_group.asg_group.name
  recurrence             = var.schedule_cron_start
}
