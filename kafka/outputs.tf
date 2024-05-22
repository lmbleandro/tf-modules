output "zookeeper_connect_string" {
  value = aws_msk_cluster.this.zookeeper_connect_string
}

output "bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value       = aws_msk_cluster.this.bootstrap_brokers_tls
}

output "security_group" {
  value = aws_security_group.this.id
}