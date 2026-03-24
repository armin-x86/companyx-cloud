# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_patch_baseline
module "ubuntu_patch_manager" {
  source           = "../../../modules/ssm/patch_manager"
  namespace        = module.config.global.namespace
  name             = "al2023"
  operating_system = "AMAZON_LINUX_2023"
  patch_group      = "al2023"
  # Same tag key as on EC2 instances (e.g. nginx): "${namespace}/patch-group" = patch_group
  instance_patch_tag_key = "${module.config.global.namespace}/patch-group"
  # https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-scheduled-rule-pattern.html
  maintenance_window_scan_schedule    = "cron(0 2 ? * * *)" # Every day at 2 AM
  maintenance_window_install_schedule = "cron(0 4 ? * * *)" # Every day at 4 AM

  patch_baseline_approval_rules = [
    {
      approve_after_days  = 3
      compliance_level    = "HIGH"
      enable_non_security = false
      patch_baseline_filters = [
        {
          key    = "PRODUCT"
          values = ["*"]
        },
        {
          key    = "CLASSIFICATION"
          values = ["*"]
        },
        {
          key    = "SEVERITY"
          values = ["*"]
        }
      ]
    }
  ]
}
