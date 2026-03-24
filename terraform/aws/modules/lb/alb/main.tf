# trivy:ignore:avd-aws-0053
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name               = var.alb_name
  load_balancer_type = "application"
  vpc_id             = var.vpc_id
  subnets            = var.subnets

  internal              = var.internal
  security_groups       = var.security_groups
  create_security_group = false

  listeners = var.listeners

  target_groups                       = var.target_groups
  additional_target_group_attachments = var.additional_target_group_attachments

  # Loadbalancer attributes
  preserve_host_header             = var.preserve_host_header
  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  access_logs = {
    enabled = length(var.logs_s3_bucket_id) > 0
    bucket  = var.logs_s3_bucket_id
    prefix  = "${var.alb_name}/access-logs"
  }

  connection_logs = {
    enabled = length(var.logs_s3_bucket_id) > 0
    bucket  = var.logs_s3_bucket_id
    prefix  = "${var.alb_name}/connection-logs"
  }

  tags = var.tags
}
