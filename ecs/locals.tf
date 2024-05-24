locals {
  cluster_tags = {
    Tools   = "terraform"
  }
  app_name       = var.cluster_name
  tag               = var.tags
}