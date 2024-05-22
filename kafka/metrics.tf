# Definição das Métricas
# https://cortex-confluence.atlassian.net/wiki/spaces/devops/pages/574783495/MSK+Kafka#Principais-M%C3%A9tricas-/-Threshold


#######################################################################
# Metrics per Broker
#######################################################################

resource "aws_cloudwatch_metric_alarm" "warn_cpu_system" {
  count                     = var.enabled_metrics ? var.number_of_broker_nodes : 0
  alarm_name                = "msk-${var.cluster_name}-b${count.index + 1}-warn-cpu-system"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 15
  metric_name               = "CpuSystem"
  namespace                 = "AWS/Kafka"
  period                    = var.period
  statistic                 = "Average"
  threshold                 = 70
  alarm_description         = "CpuSystem - The percentage of CPU in kernel space"
  alarm_actions             = var.alarm_topic
  ok_actions                = var.alarm_topic
  insufficient_data_actions = []

  dimensions = {
    "Cluster Name" = "${var.cluster_name}"
    "Broker ID"    = "${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "crit_cpu_system" {
  count                     = var.enabled_metrics ? var.number_of_broker_nodes : 0
  alarm_name                = "msk-${var.cluster_name}-b${count.index + 1}-crit-cpu-system"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 10
  metric_name               = "CpuSystem"
  namespace                 = "AWS/Kafka"
  period                    = var.period
  statistic                 = "Average"
  threshold                 = 90
  alarm_description         = "CpuSystem - The percentage of CPU in kernel space"
  alarm_actions             = var.alarm_topic
  ok_actions                = var.alarm_topic
  insufficient_data_actions = []

  dimensions = {
    "Cluster Name" = "${var.cluster_name}"
    "Broker ID"    = "${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "warn_cpu_user" {
  count                     = var.enabled_metrics ? var.number_of_broker_nodes : 0
  alarm_name                = "msk-${var.cluster_name}-b${count.index + 1}-warn-cpu-user"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 15
  metric_name               = "CpuUser"
  namespace                 = "AWS/Kafka"
  period                    = var.period
  statistic                 = "Average"
  threshold                 = 70
  alarm_description         = "CpuUser - The percentage of CPU in user space"
  alarm_actions             = var.alarm_topic
  ok_actions                = var.alarm_topic
  insufficient_data_actions = []

  dimensions = {
    "Cluster Name" = "${var.cluster_name}"
    "Broker ID"    = "${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "crit_cpu_user" {
  count                     = var.enabled_metrics ? var.number_of_broker_nodes : 0
  alarm_name                = "msk-${var.cluster_name}-b${count.index + 1}-crit-cpu-user"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 10
  metric_name               = "CpuUser"
  namespace                 = "AWS/Kafka"
  period                    = var.period
  statistic                 = "Average"
  threshold                 = 90
  alarm_description         = "CpuUser - The percentage of CPU in user space"
  alarm_actions             = var.alarm_topic
  ok_actions                = var.alarm_topic
  insufficient_data_actions = []

  dimensions = {
    "Cluster Name" = "${var.cluster_name}"
    "Broker ID"    = "${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "warn_kafka_data_logs_disk_used" {
  count                     = var.enabled_metrics ? var.number_of_broker_nodes : 0
  alarm_name                = "msk-${var.cluster_name}-b${count.index + 1}-warn-kafka-data-logs-disk-used"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 15
  metric_name               = "KafkaDataLogsDiskUsed"
  namespace                 = "AWS/Kafka"
  period                    = var.period
  statistic                 = "Average"
  threshold                 = 70
  alarm_description         = "KafkaDataLogsDiskUsed - The percentage of disk space used for data logs"
  alarm_actions             = var.alarm_topic
  ok_actions                = var.alarm_topic
  insufficient_data_actions = []

  dimensions = {
    "Cluster Name" = "${var.cluster_name}"
    "Broker ID"    = "${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "crit_kafka_data_logs_disk_used" {
  count                     = var.enabled_metrics ? var.number_of_broker_nodes : 0
  alarm_name                = "msk-${var.cluster_name}-b${count.index + 1}-crit-kafka-data-logs-disk-used"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 10
  metric_name               = "KafkaDataLogsDiskUsed"
  namespace                 = "AWS/Kafka"
  period                    = var.period
  statistic                 = "Average"
  threshold                 = 90
  alarm_description         = "KafkaDataLogsDiskUsed - The percentage of disk space used for data logs"
  alarm_actions             = var.alarm_topic
  ok_actions                = var.alarm_topic
  insufficient_data_actions = []

  dimensions = {
    "Cluster Name" = "${var.cluster_name}"
    "Broker ID"    = "${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "warn_root_disk_used" {
  count                     = var.enabled_metrics ? var.number_of_broker_nodes : 0
  alarm_name                = "msk-${var.cluster_name}-b${count.index + 1}-warn-root-disk-used"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 15
  metric_name               = "RootDiskUsed"
  namespace                 = "AWS/Kafka"
  period                    = var.period
  statistic                 = "Average"
  threshold                 = 70
  alarm_description         = "RootDiskUsed - The percentage of the root disk used by the broker"
  alarm_actions             = var.alarm_topic
  ok_actions                = var.alarm_topic
  insufficient_data_actions = []

  dimensions = {
    "Cluster Name" = "${var.cluster_name}"
    "Broker ID"    = "${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "crit_root_disk_used" {
  count                     = var.enabled_metrics ? var.number_of_broker_nodes : 0
  alarm_name                = "msk-${var.cluster_name}-b${count.index + 1}-crit-root-disk-used"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 10
  metric_name               = "RootDiskUsed"
  namespace                 = "AWS/Kafka"
  period                    = var.period
  statistic                 = "Average"
  threshold                 = 90
  alarm_description         = "RootDiskUsed - The percentage of the root disk used by the broker"
  alarm_actions             = var.alarm_topic
  ok_actions                = var.alarm_topic
  insufficient_data_actions = []

  dimensions = {
    "Cluster Name" = "${var.cluster_name}"
    "Broker ID"    = "${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "warn_heap_memory_after_gc" {
  count                     = var.enabled_metrics ? var.number_of_broker_nodes : 0
  alarm_name                = "msk-${var.cluster_name}-b${count.index + 1}-warn-heap-memory-after-gc"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 15
  metric_name               = "HeapMemoryAfterGC"
  namespace                 = "AWS/Kafka"
  period                    = var.period
  statistic                 = "Average"
  threshold                 = 70
  alarm_description         = "HeapMemoryAfterGC - The percentage of total heap memory in use after garbage collection"
  alarm_actions             = var.alarm_topic
  ok_actions                = var.alarm_topic
  insufficient_data_actions = []

  dimensions = {
    "Cluster Name" = "${var.cluster_name}"
    "Broker ID"    = "${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "crit_heap_memory_after_gc" {
  count                     = var.enabled_metrics ? var.number_of_broker_nodes : 0
  alarm_name                = "msk-${var.cluster_name}-b${count.index + 1}-crit-heap-memory-after-gc"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 10
  metric_name               = "HeapMemoryAfterGC"
  namespace                 = "AWS/Kafka"
  period                    = var.period
  statistic                 = "Average"
  threshold                 = 90
  alarm_description         = "HeapMemoryAfterGC - The percentage of total heap memory in use after garbage collection"
  alarm_actions             = var.alarm_topic
  ok_actions                = var.alarm_topic
  insufficient_data_actions = []

  dimensions = {
    "Cluster Name" = "${var.cluster_name}"
    "Broker ID"    = "${count.index + 1}"
  }
}


#######################################################################
# Metrics per Topics
#######################################################################

resource "aws_cloudwatch_metric_alarm" "warn_estimated_max_time_lag" {
  count                     = var.enabled_metrics ? length(var.topics_metrics) : 0
  alarm_name                = "msk-${var.cluster_name}-topic-${replace(var.topics_metrics[count.index], ".", "-")}-warn-estimated-max-time-lag"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 15
  threshold                 = 1800
  alarm_description         = "EstimatedMaxTimeLag - Time estimate (in seconds) to drain MaxOffsetLag"
  alarm_actions             = var.alarm_topic
  ok_actions                = var.alarm_topic
  insufficient_data_actions = []

  metric_query {
    id          = "q1"
    expression  = "SELECT MAX(EstimatedMaxTimeLag) FROM \"AWS/Kafka\" WHERE \"Cluster Name\" = '${var.cluster_name}' AND Topic = '${var.topics_metrics[count.index]}'"
    label       = "EstimatedMaxTimeLag"
    period      = var.period
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "crit_estimated_max_time_lag" {
  count                     = var.enabled_metrics ? length(var.topics_metrics) : 0
  alarm_name                = "msk-${var.cluster_name}-topic-${replace(var.topics_metrics[count.index], ".", "-")}-crit-estimated-max-time-lag"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 10
  threshold                 = 3600
  alarm_description         = "EstimatedMaxTimeLag - Time estimate (in seconds) to drain MaxOffsetLag"
  alarm_actions             = var.alarm_topic
  ok_actions                = var.alarm_topic
  insufficient_data_actions = []

  metric_query {
    id          = "q1"
    expression  = "SELECT MAX(EstimatedMaxTimeLag) FROM \"AWS/Kafka\" WHERE \"Cluster Name\" = '${var.cluster_name}' AND Topic = '${var.topics_metrics[count.index]}'"
    label       = "EstimatedMaxTimeLag"
    period      = var.period
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "warn_bytes_in_per_sec" {
  count                     = var.enabled_metrics ? length(var.topics_metrics) : 0
  alarm_name                = "msk-${var.cluster_name}-topic-${replace(var.topics_metrics[count.index], ".", "-")}-warn-bytes-in-per-sec"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = 5
  threshold                 = 1
  alarm_description         = "BytesInPerSec - The number of bytes per second received from clients. This metric is available per broker and also per topic"
  alarm_actions             = var.alarm_topic
  ok_actions                = var.alarm_topic
  insufficient_data_actions = []

  metric_query {
    id          = "q1"
    expression  = "SELECT COUNT(BytesInPerSec) FROM \"AWS/Kafka\" WHERE \"Cluster Name\" = '${var.cluster_name}' AND Topic = '${var.topics_metrics[count.index]}'"
    label       = "BytesInPerSec"
    period      = var.period
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "crit_bytes_in_per_sec" {
  count                     = var.enabled_metrics ? length(var.topics_metrics) : 0
  alarm_name                = "msk-${var.cluster_name}-topic-${replace(var.topics_metrics[count.index], ".", "-")}-crit-bytes-in-per-sec"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = 15
  threshold                 = 1
  alarm_description         = "BytesInPerSec - The number of bytes per second received from clients. This metric is available per broker and also per topic"
  alarm_actions             = var.alarm_topic
  ok_actions                = var.alarm_topic
  insufficient_data_actions = []

  metric_query {
    id          = "q1"
    expression  = "SELECT COUNT(BytesInPerSec) FROM \"AWS/Kafka\" WHERE \"Cluster Name\" = '${var.cluster_name}' AND Topic = '${var.topics_metrics[count.index]}'"
    label       = "BytesInPerSec"
    period      = var.period
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "warn_bytes_out_per_sec" {
  count                     = var.enabled_metrics ? length(var.topics_metrics) : 0
  alarm_name                = "msk-${var.cluster_name}-topic-${replace(var.topics_metrics[count.index], ".", "-")}-warn-bytes-out-per-sec"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = 5
  threshold                 = 1
  alarm_description         = "BytesOutPerSec - The number of bytes per second sent to clients. This metric is available per broker and also per topic"
  alarm_actions             = var.alarm_topic
  ok_actions                = var.alarm_topic
  insufficient_data_actions = []

  metric_query {
    id          = "q1"
    expression  = "SELECT COUNT(BytesOutPerSec) FROM \"AWS/Kafka\" WHERE \"Cluster Name\" = '${var.cluster_name}' AND Topic = '${var.topics_metrics[count.index]}'"
    label       = "BytesOutPerSec"
    period      = var.period
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_alarm" "crit_bytes_out_per_sec" {
  count                     = var.enabled_metrics ? length(var.topics_metrics) : 0
  alarm_name                = "msk-${var.cluster_name}-topic-${replace(var.topics_metrics[count.index], ".", "-")}-crit-bytes-out-per-sec"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = 15
  threshold                 = 1
  alarm_description         = "BytesOutPerSec - The number of bytes per second sent to clients. This metric is available per broker and also per topic"
  alarm_actions             = var.alarm_topic
  ok_actions                = var.alarm_topic
  insufficient_data_actions = []

  metric_query {
    id          = "q1"
    expression  = "SELECT COUNT(BytesOutPerSec) FROM \"AWS/Kafka\" WHERE \"Cluster Name\" = '${var.cluster_name}' AND Topic = '${var.topics_metrics[count.index]}'"
    label       = "BytesOutPerSec"
    period      = var.period
    return_data = "true"
  }
}