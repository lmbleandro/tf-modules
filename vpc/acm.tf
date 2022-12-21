resource "aws_acm_certificate" "cert" {
  domain_name       = "*.cortex-intelligence.com"
  validation_method = "DNS"

  tags = {
    Environment = "Production"
    Name = "cortex-intelligence.com"
  }

  lifecycle {
    create_before_destroy = true
  }
}
