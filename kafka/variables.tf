variable "region" {
  description = "The AWS region to create things in."
}

variable "instance_type" {
  description = "Specify the instance type to use for the kafka brokers. e.g. kafka.m5.large. ([Pricing info](https://aws.amazon.com/msk/pricing/))"
}

variable "kafka_version" {
  description = "Specify the desired Kafka software version"
  type        = string
  default     = null
}
variable "cluster_name" {
  description = "Name of the MSK cluster"
  type        = string
}

variable "vpc_id" {
  description = "Vpc id"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for Client Broker"
}

variable "number_of_broker_nodes" {
  description = "The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets"
  type        = number
  default     = null
}

variable "enhanced_monitoring" {
  description = "Specify the desired enhanced MSK CloudWatch monitoring level. See [Monitoring Amazon MSK with Amazon CloudWatch](https://docs.aws.amazon.com/msk/latest/developerguide/monitoring.html)"
  type        = string
  default     = null
}

variable "enable_jmx_exporter" {
  description = "Indicates whether you want to enable or disable the JMX Exporter"
  type = bool
  default = true
}

variable "enable_node_export" {
  description = "Indicates whether you want to enable or disable the Node Exporter"
  type = bool
  default = true
}

variable "cloudwatch_logs_enabled" {
  description = "Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs"
  type        = bool
  default     = false
}

variable "s3_logs_enabled" {
  description = "Indicates whether you want to enable or disable streaming broker logs to S3"
  type        = bool
  default     = false
}

variable "ebs_volume_size" {
  description = "The AWS region to create things in."

}

variable "cloudwatch_log_group_name" {
  description = "Name of the Cloudwatch Log Group to deliver logs to"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the log group"
  type        = number
  default     = 1
}

variable "enabled_metrics" {
  description = "If true, it enables the creation of metrics"
  type        = bool
  default     = true
}

variable "period" {
  description = "The period in seconds over which the specified statistic is applied. Valid values are 10, 30, or any multiple of 60"
  type = number
  default = 60
}

variable "topics_metrics" {
  description = "List of topics that should be monitored"
  type = list(string)
}

variable "alarm_topic" {
  description = "ARN of the SNS topic used for alarm notification"
  type        = list(string)
}

variable "tags" {
  description = "The AWS tags"
}

variable ingress_rules {
    type = list( object({ 
    from_port = number 
    to_port = number 
    protocol = string 
    security_groups = list(string)
    cidr_blocks = list(string) 
  }))
}