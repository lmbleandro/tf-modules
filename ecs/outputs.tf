

#output "cloudwatch_log_groups" {
#  value = aws_cloudwatch_log_group.this.name
#}

//output "repository" {
//  value = aws_ecr_repository.this.repository_url
//}

output "cluster" {
  value = aws_ecs_cluster.this.name
}

output "application_load_balancer_name" {
  value = aws_lb.this.dns_name
}

output "application_load_balancer_id" {
  value = aws_lb.this.id
}

output "application_load_balancer_sg" {
  value = aws_security_group.alb.id
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "target_group_id" {
  value = aws_lb_target_group.this.id
}

output "listener_80" {
  value = aws_alb_listener.this.id
}

output "listener_arn_80" {
  value = aws_alb_listener.this.arn
}


