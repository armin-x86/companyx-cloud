locals {
  aws_account = data.aws_caller_identity.current.account_id
}

data "aws_iam_policy_document" "cost_report" {
  statement {
    sid    = "AWSCURExportPolicy"
    effect = "Allow"
    principals {
      identifiers = [
        "bcm-data-exports.amazonaws.com",
        "billingreports.amazonaws.com",
      ]
      type = "Service"
    }
    resources = [
      "arn:aws:s3:::${module.config.global.organisation}-${module.config.global.business_unit}-cost-report-${module.config.environment}",
      "arn:aws:s3:::${module.config.global.organisation}-${module.config.global.business_unit}-cost-report-${module.config.environment}/*",
    ]
    actions = [
      "s3:PutObject",
      "s3:GetBucketPolicy"
    ]
    condition {
      test     = "StringLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:cur:us-east-1:${local.aws_account}:definition/*",
        "arn:aws:bcm-data-exports:us-east-1:${local.aws_account}:export/*"
      ]
    }
    condition {
      test     = "StringLike"
      variable = "aws:SourceAccount"
      values   = [local.aws_account]
    }
  }
}
