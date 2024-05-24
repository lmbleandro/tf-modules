
output "cluster" {
  value = aws_ecs_cluster.this.name
}

output "autoscaling_group_name_id" {
  value = aws_autoscaling_group.this.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.this.name
}

output "aws_security_group_autoscaling_id" {
  value = aws_security_group.autoscaling.id
}