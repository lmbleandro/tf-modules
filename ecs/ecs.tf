resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

/*
resource "aws_ecs_cluster_capacity_providers" "this" {
  #count = var.enable_capacity_providers ? 1 : 0
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = [aws_ecs_capacity_provider.this.name]
}

resource "aws_ecs_capacity_provider" "this" {
  #count = var.enable_capacity_providers ? 1 : 0
  name = "${var.cluster_name}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.this.arn

    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}
*/
