locals {
  app_name       = var.cluster_name
  container_name = "${local.app_name}-container"
  //autoscaling_resource_id = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  ecs_ec2_role_name = "${local.app_name}-${var.ecs_ec2_role_name}"
  tag               = var.tags
}