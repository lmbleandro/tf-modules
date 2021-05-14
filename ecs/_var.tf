
variable "region" {
  default = "us-east-1"
}

variable "profile" {}

variable "vpc_id" {}
variable "cluster_name" {
  default = "engenharia"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "on_demand_base_capacity" {
  default = "0"
}
variable "on_demand_percentage" {
  default = "0"
}
//variable "key_pair" {
//  default = "engenharia"
//}

variable "accountId" {
  default = "385628043044"
}


variable "tags" {
  default = {
    "Environment" = "dev"
    "Team"        = "production-engineering"
    "Tools"       = "terraform"
  }
}

variable "ecs_auto_scale_role_name" {
  default = "EcsAutoScaleRole"
}

variable "ecs_ec2_role_name" {
  default = "Ec2EcsInstanceRole"
}


variable "path_pattern_service" {
  default = "teste"
}
variable "alb_port_https" {
  default = 443
}
variable "alb_port" {
  default = 80
}

variable "task_count" {
  default = 1
}

variable "env_container" {
  default = "dev"
}

variable "autoscale_enabled" {
  description = "Setup autoscale."
  default     = "true"
}
variable "enable_schedule" {
  default = true
}

variable "desired_count_asg_max" {
  default = 2
}
variable "desired_count_asg_mim" {
  default = 1
}

variable "schedule_cron_start" {
  type        = string
  default     = "00 12 * * 1-5"
  description = "Cron expression to define when to trigger a start of the auto-scaling group. E.g. '0 20 * * *' to start at 8pm GMT time"
}

variable "schedule_cron_stop" {
  type        = string
  default     = "00 00 * * 1-5"
  description = "Cron expression to define when to trigger a stop of the auto-scaling group. E.g. '0 10 * * *' to stop at 10am GMT time"
}

variable "target_group_arns" {
  default     = []
  type        = list(string)
  description = "List of target groups for ASG to register"
}