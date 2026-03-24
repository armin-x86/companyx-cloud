output "organisation" {
  description = "The name of the organisation"
  value       = local.organisation
}

output "business_unit" {
  description = "The name of the business_unit"
  value       = local.business_unit
}

output "namespace" {
  description = "The namespace of organisation"
  value       = local.namespace
}

output "root_domain" {
  description = "The name of the root domain"
  value       = local.root_domain
}

output "root_domain_reverse" {
  description = "The reversed name of the root domain"
  value = join(
    ".",
    reverse(
      split(".", local.root_domain)
    )
  )
}

output "secrets_namespace" {
  description = "The namespace of secrets"
  value       = local.secrets_namespace
}

output "aws_accounts" {
  description = "The map of AWS account names/numbers."
  value       = local.aws_accounts
}

output "ip_cidr_ranges" {
  description = "IP CIDR ranges for use in all terraform resources"
  value       = local.ip_cidr_ranges
}

output "vpn" {
  description = "The VPN configuration details"
  value       = local.vpn
}

output "default_tags" {
  description = "The default tags for the project"
  value = {
    "${local.namespace}/terraform"     = "true"
    "${local.namespace}/organisation"  = local.organisation
    "${local.namespace}/business_unit" = local.business_unit
  }
}
