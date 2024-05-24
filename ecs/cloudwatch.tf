/*
resource "aws_autoscaling_policy" "ASGAverageCPUUtilization" {
  count = var.enable_autoscale_asg ? 1 : 0
  name = "${aws_autoscaling_group.this.name}-cpu_utilization"

  autoscaling_group_name = aws_autoscaling_group.this.name
  policy_type            = "TargetTrackingScaling"
  estimated_instance_warmup = 30

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = "80"
  }
}
*/

#inicio nova implementação 
  
# Alarmes sobre os cluster ECS
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  count = var.enable_autoscale_up ? 1 : 0

  alarm_name          = "${aws_autoscaling_group.this.name}-cpu_utilization_high"
  comparison_operator = "GreaterThanThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  evaluation_periods  = var.cluster_cpu_utilization_high_evaluation_periods
  period              = var.cluster_cpu_utilization_high_period
  threshold           = var.cluster_cpu_utilization_high_threshold
  alarm_description   = format("Media de utilização CPU ALTA nos ultimos %d minuto(s)", var.cluster_cpu_utilization_high_period/60)

  //alarm_actions       = [aws_cloudformation_stack.sns_topic[count.index].id]
  //ok_actions          = [aws_cloudformation_stack.sns_topic[count.index].id]

  dimensions ={
    ClusterName = aws_autoscaling_group.this.name
  }

  tags = merge(var.tags, { 
    Name           = "cpu-utilization-high"
    //environment    = var.env
  },)
}

resource "aws_cloudwatch_metric_alarm" "memory_utilization_high" {
  count = var.enable_autoscale_up  ? 1 : 0

  alarm_name          = "${aws_autoscaling_group.this.name}-memory_utilization_high"
  comparison_operator = "GreaterThanThreshold"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = var.cluster_memory_utilization_high_period
  evaluation_periods  = var.cluster_memory_utilization_high_evaluation_periods
  threshold           = var.cluster_memory_utilization_high_threshold
  alarm_description   = format("Media de utilizacao MEMORIA ALTA nos ultimos %d minuto(s)", var.cluster_memory_utilization_high_period/60)

  //alarm_actions       = [aws_cloudformation_stack.sns_topic[count.index].id]
  //ok_actions          = [aws_cloudformation_stack.sns_topic[count.index].id]

  dimensions = {
    ClusterName = aws_autoscaling_group.this.name
  }
  
  tags = merge(var.tags, { 
    Name           = "memory-utilization-high"
    //environment    = var.env
  },)  
}

# Alarmes sobre os ASGs
resource "aws_cloudwatch_metric_alarm" "StatusCheckFailed_System" {
  count = var.enable_autoscale_up  ? 1 : 0

  alarm_name          = "${aws_autoscaling_group.this.name}-StatusCheckFailed_System"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_description = "Notifica se uma instância falhou no StatusCheckFailed_System"
  //ok_actions        =  [aws_cloudformation_stack.sns_topic[count.index].id]
  //alarm_actions     =  [aws_cloudformation_stack.sns_topic[count.index].id]
  //insufficient_data_actions = [aws_cloudformation_stack.sns_topic[count.index].id]

  tags = merge(var.tags, { 
    Name           = "StatusCheckFailed_System"
    //environment    = var.env
  },)  
}


resource "aws_cloudwatch_metric_alarm" "StatusCheckFailed" {
  count = var.enable_autoscale_up ? 1 : 0

  alarm_name          = "${aws_autoscaling_group.this.name}-StatusCheckFailed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"


  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_description = "Notifica se uma instância falhou no StatusCheckFailed"
  //ok_actions        =  [aws_cloudformation_stack.sns_topic[count.index].id]
  //alarm_actions     =  [aws_cloudformation_stack.sns_topic[count.index].id]
  //insufficient_data_actions = [aws_cloudformation_stack.sns_topic[count.index].id]
 
  tags = merge(var.tags, { 
    Name           = "StatusCheckFailed"
    //environment    = var.env
  },)
}

resource "aws_cloudwatch_metric_alarm" "StatusCheckFailed_Instance" {
  count = var.enable_autoscale_up ? 1 : 0

  alarm_name          = "${aws_autoscaling_group.this.name}-StatusCheckFailed_Instance"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"


  dimensions = {
    //AutoScalingGroupName = aws_autoscaling_group.this.name
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_description = "Notifica se uma instância falhou no StatusCheckFailed_Instance"
  //ok_actions        =  [aws_cloudformation_stack.sns_topic[count.index].id]
  //alarm_actions     =  [aws_cloudformation_stack.sns_topic[count.index].id]
  //insufficient_data_actions = [aws_cloudformation_stack.sns_topic[count.index].id]
  tags = merge(var.tags, { 
    Name           = "StatusChekFailed_Instance"
    //environment    = var.env
  },)
}