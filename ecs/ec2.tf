
resource "aws_launch_template" "ecs_launch_template" {
  name_prefix = var.cluster_name
  instance_type = var.instance_type
  image_id = var.is_ami_type_arm ? data.aws_ami.amzn_arm.id : data.aws_ami.amzn.id
  #vpc_security_group_ids = [ aws_security_group.autoscaling.id ]
  
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_role.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_type = var.volume_type      
      volume_size = var.instance_volume_size
      throughput  = var.throughput
      iops        = var.iops
    }
  }

    monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups = [aws_security_group.autoscaling.id]
  }


  credit_specification {
    cpu_credits = var.instance_credit_specification
  }

  user_data = base64encode(
    templatefile(
      "${path.module}/templates/ecs_init.tpl",
      {
        cluster_name = var.cluster_name
      }
    )
  )   
  tags = var.tags
}


resource "aws_autoscaling_group" "this" {
  name                      = "${local.app_name}-scale_group"
  capacity_rebalance        = true
  desired_capacity          = var.desired_capacity_instance_cluster
  max_size                  = var.max_size_desired_instance_cluster
  min_size                  = var.min_size_desired_instance_cluster
  default_cooldown = "300"
  vpc_zone_identifier       = var.private_subnets
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
    "GroupInServiceCapacity",
    "GroupPendingCapacity",
    "GroupStandbyCapacity",
    "GroupTerminatingCapacity",
    "GroupTotalCapacity"
  ]
  metrics_granularity = "1Minute"
  
  health_check_grace_period = 60

  mixed_instances_policy {
    instances_distribution {
       on_demand_base_capacity = var.on_demand_base_capacity #This valu cant to be less var.desired_count_asg_max
       on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
       spot_allocation_strategy = var.spot_allocation_strategy
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.ecs_launch_template.id
        version = "$Latest"
      }
      dynamic "override" {
        for_each = var.override_instance_type
        content {
          instance_type = override.value.instance_type
          weighted_capacity = override.value.weighted_capacity
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [ desired_capacity]
  }
  dynamic tag {
    for_each = merge(local.cluster_tags,var.tags)
      content {
        key = tag.key
        value = tag.value
        propagate_at_launch = true
      }
    }
}

resource "aws_autoscaling_schedule" "ecs_stop" {
  count                  = var.enable_schedule_stop ? 1 : 0
  scheduled_action_name  = "ecs-${local.app_name}-stop"
  time_zone              = "America/Sao_Paulo"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  autoscaling_group_name = aws_autoscaling_group.this.name
  recurrence             = var.schedule_cron_stop
}

resource "aws_autoscaling_schedule" "ecs_start" {
  count                  = var.enable_schedule_start ? 1 : 0
  scheduled_action_name  = "ecs-${local.app_name}-start"
  time_zone              = "America/Sao_Paulo"
  min_size               = var.min_size_desired_instance_cluster
  max_size               = var.max_size_desired_instance_cluster
  desired_capacity       = var.desired_capacity_instance_cluster
  autoscaling_group_name = aws_autoscaling_group.this.name
  recurrence             = var.schedule_cron_start
}
