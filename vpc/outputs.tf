output "vpc" {
  value = aws_vpc.this.id
  description = "name of the docker container"
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private.*.id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public.*.id
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.private.*.arn
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.public.*.arn
}

output "eip_nat_gateway" {
  value = aws_nat_gateway.this.private_ip
}

output "sg_cortex_default_id" {
  value = aws_security_group.this_sg.id
}

output "sg_cortex_default_name" {
  value = aws_security_group.this_sg.name
}