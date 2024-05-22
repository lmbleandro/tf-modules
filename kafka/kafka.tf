resource "aws_cloudwatch_log_group" "kafka" {
  name = "/aws/msk/${var.cluster_name}"
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
  tags = var.tags
}

resource "aws_kms_key" "kms" {
  description = var.cluster_name
  tags = var.tags
}

resource "aws_msk_cluster" "this" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  enhanced_monitoring    = var.enhanced_monitoring

  broker_node_group_info {
    instance_type   = var.instance_type
    ebs_volume_size = var.ebs_volume_size
    client_subnets = var.subnet_ids
    security_groups = [ aws_security_group.this.id ]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.kms.arn
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = var.enable_jmx_exporter
      }
      node_exporter {
        enabled_in_broker = var.enable_node_export
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled = var.cloudwatch_logs_enabled
        log_group = var.cloudwatch_logs_enabled ? aws_cloudwatch_log_group.kafka.name : null
      }
    }
  }

  # required for appautoscaling
  lifecycle {
    ignore_changes = [broker_node_group_info[0].ebs_volume_size]
  }

  tags = var.tags
}