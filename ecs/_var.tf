variable "cluster_name" {
  description = "Nome Cluster"
  type        = string
}

variable "private_subnets" {
  type        = list(string)
  description = "List of subnet IDs to use"
}

variable "vpc_id" {
  description = "id da vpc que sera usada para criacao de recursos"
  type        = string
}

variable "instance_type" {
  description = "tipo de instancia"
  type        = string
}

variable "enable_schedule_stop" {
  description = "As ec2 do cluster serão desligadas?"
  type        = string
}

variable "enable_schedule_start" {
  description = "As ec2 do cluster serão ligadas?"
  type        = string
}

variable "tags" {
  description = "Tags para os recursos "
  type        = map(string)
}

variable "schedule_cron_start" {
  type        = string
  default     = "00 08 * * 1-5"
  description = "Cron expression to define when to trigger a start of the auto-scaling group. E.g. '0 20 * * *' to start at 8pm GMT time"
}

variable "schedule_cron_stop" {
  type        = string
  default     = "00 20 * * 1-5"
  description = "Cron expression to define when to trigger a stop of the auto-scaling group. E.g. '0 10 * * *' to stop at 10am GMT time"
}

variable "is_ami_type_arm" {
  type        = bool
  description = "Coloque true caso a instance type for da familia arm(Graviton)"
  default     = true
}

variable "enable_autoscale_up" {
  type    = bool
  default = true
}

variable "enable_autoscale_down" {
  type    = bool
  default = false
}

variable "enable_autoscale_asg" {
  type    = bool
  default = false
}

/*
 * Monitoramento
 */
variable "cluster_cpu_utilization_high_threshold" {
  description = "CPU threshold for auto scaling rule"
  type        = number
  default     = 90
}

variable "cluster_cpu_utilization_high_period" {
  description = "Evaluation time in milliseconds"
  type        = number
  default     = 300
}

variable "cluster_cpu_utilization_high_evaluation_periods" {
  description = "Cycles evaluation periods"
  type        = number
  default     = 1
}
variable "cluster_memory_utilization_high_period" {
  description = "Evaluation time in milliseconds"
  type        = number
  default     = 300
}

variable "cluster_memory_utilization_high_evaluation_periods" {
  description = "Cycles evaluation periods"
  type        = number
  default     = 1
}

variable "cluster_memory_utilization_high_threshold" {
  description = "Memory threshold for auto scaling rule"
  type        = number
  default     = 90
}

#new variables

variable "desired_capacity_instance_cluster" {
  description = "Number of EC2 instances that will be created"
  type        = number
  default     = 1
}

variable "max_size_desired_instance_cluster" {
  description = "numero máximo de instancias do cluster"
  type        = number
  default     = 1
}
variable "min_size_desired_instance_cluster" {
  description = "numero minimo de instancias do cluster"
  type        = number
  default     = 1
}

variable "instance_volume_size" {
  default = "50"
}

variable "volume_type" {
  default = "gp3"
}

variable "throughput" {
  default = 125
}

variable "iops" {
  default = 3000
}

variable "instance_credit_specification" {
  description = "Instance credit specification, only supports standard and unlimited"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "unlimited"], var.instance_credit_specification)
    error_message = "Valid values for instance_credit_specification are (standard and unlimited)."
  }
}
variable "override_instance_type" {
  description = "List of instances that will created after the on_demand_base_capacity be attended"
  type = list(object({
    instance_type     = string
    weighted_capacity = string

  }))

  default = [
    {
      instance_type     = "c6g.large"
      weighted_capacity = "1"
    },
    {
      instance_type     = "c7g.large"
      weighted_capacity = "1"
    },
    {
      instance_type     = "m6g.large"
      weighted_capacity = "1"
    },
    {
      instance_type     = "c7g.xlarge"
      weighted_capacity = "1"
    }
  ]
}


variable "on_demand_base_capacity" {
  description = "numero máximo de instancias do cluster"
  type        = string
  default     = "1"
}

variable "on_demand_percentage_above_base_capacity" {
  description = "On Demand percentage of instances that will be created above the on_demand_base_capacity"
  type        = number
  default     = 100
}

variable "spot_allocation_strategy" {
  description = "Spot allocation strategy"
  type        = string
  default     = "capacity-optimized"

  validation {
    condition     = contains(["lowest-price", "capacity-optimized", "capacity-optimized-prioritized", "price-capacity-optimized"], var.spot_allocation_strategy)
    error_message = "Valid values for spot_allocation_strategy are (lowest-price, capacity-optimized, capacity-optimized-prioritized, price-capacity-optimized)."
  }
}

variable "enable_awsvpc_truncking" {
  type    = bool
  default = false
}

variable "lista_alb_origem_acesso" {
  type = list(string)
  default = []
}

variable "inbound_rules" {
  default = []
}

variable "asg_schedules" {
  description = "A map of all schedules to apply to the autoscaling groups."
  type        = map(object({
    min_size          = number,
    max_size          = number,
    desired_capacity  = number,
    recurrence        = string,
    time_zone         = string
  }))
  default     = {}
}


variable "associate_public_ip_address" {
    type    = bool
    default = false
}