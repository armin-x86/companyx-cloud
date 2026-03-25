locals {
  buckets = {
    cost-report = {
      policy                    = data.aws_iam_policy_document.cost_report.json
      append_environment_suffix = true
    }
    athena = {
      lifecycle_rules = [
        {
          id      = "expire-old-queries"
          enabled = true
          expiration = {
            days = 3
          }
        }
      ]
      append_environment_suffix = true
    }
    lb-access-logs = {
      policy        = data.aws_iam_policy_document.lb_access_logs.json
      sse_algorithm = "AES256"
      lifecycle_rules = [
        {
          id      = "remove-old-logs"
          enabled = true
          expiration = {
            days = 7
          }
        }
      ]
      append_environment_suffix = true
    }
    # Staging area for amazon.aws.aws_ssm (Ansible): presigned S3 uploads/downloads for module payloads.
    ansible-ssm = {
      policy                    = data.aws_iam_policy_document.ansible_ssm_bucket_access.json
      sse_algorithm             = "AES256"
      versioning_status         = "Suspended"
      enable_logging            = false
      append_environment_suffix = true
      lifecycle_rules = [
        {
          id      = "expire-temp-ansible-ssm-objects"
          enabled = true
          expiration = {
            days = 7
          }
        }
      ]
    }
  }
}

# This should exist in every AWS account
module "s3_simple" {
  source        = "../../../modules/s3/simple"
  organisation  = module.config.global.organisation
  business_unit = module.config.global.business_unit
  namespace     = module.config.global.namespace
  environment   = module.config.environment
  buckets       = local.buckets
  tags          = module.config.default_tags
}
