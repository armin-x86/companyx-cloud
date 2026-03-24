output "global" {
  description = "Global configuration"
  value       = module.global
}

output "environment" {
  description = "Environment configuration"
  value       = local.environment
}

output "aws_region" {
  description = "AWS Region"
  value       = local.aws_region
}

output "secrets_namespace" {
  description = "The namespace of secrets for otc staging"
  value       = local.secrets_namespace
}

output "r53_zone" {
  description = "Route53 Zone"
  value       = local.r53_zone
}

output "vpc" {
  description = "The requested VPC parameters"
  value       = local.vpc
}

output "default_tags" {
  description = "Default tags"
  value = merge(module.global.default_tags, {
    "${module.global.namespace}/environment" = local.environment
  })
}
