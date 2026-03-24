locals {
  tags = merge({
    "${var.namespace}/application" : "ssm"
  }, var.tags)
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_patch_baseline
resource "aws_ssm_patch_baseline" "baseline" {
  name             = lower("${var.name}-${var.operating_system}-baseline")
  description      = "Patch baseline requirements for the managed EC2 instances"
  operating_system = var.operating_system

  dynamic "approval_rule" {
    for_each = var.patch_baseline_approval_rules
    content {
      approve_after_days  = try(approval_rule.value.approve_after_days, null)
      approve_until_date  = try(approval_rule.value.approve_until_date, null)
      compliance_level    = approval_rule.value.compliance_level
      enable_non_security = approval_rule.value.enable_non_security
      # https://docs.aws.amazon.com/systems-manager/latest/APIReference/API_DescribePatchProperties.html
      dynamic "patch_filter" {
        for_each = approval_rule.value.patch_baseline_filters
        content {
          key    = patch_filter.value.key
          values = patch_filter.value.values
        }
      }
    }
  }

  tags = local.tags
}

resource "aws_ssm_patch_group" "patch_group" {
  baseline_id = aws_ssm_patch_baseline.baseline.id
  patch_group = var.patch_group
}
