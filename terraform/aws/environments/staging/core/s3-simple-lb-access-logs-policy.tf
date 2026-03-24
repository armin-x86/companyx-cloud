locals {
  lb_access_logs_arn = "arn:aws:s3:::${module.config.global.organisation}-${module.config.global.business_unit}-lb-access-logs-${module.config.environment}"
}

# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html
data "aws_iam_policy_document" "lb_access_logs" {
  statement {
    sid    = "ALBWriteAccessPolicy"
    effect = "Allow"
    principals {
      identifiers = [
        # Europe (Ireland) – 156460612806 (elb-account-id)
        "arn:aws:iam::${module.config.global.aws_accounts.lb_account}:root"
      ]
      type = "AWS"
    }
    resources = [
      "${local.lb_access_logs_arn}/*"
    ]
    actions = [
      "s3:PutObject"
    ]
  }

  statement {
    sid    = "NLBLogDeliveryAclCheck"
    effect = "Allow"
    principals {
      identifiers = [
        "delivery.logs.amazonaws.com"
      ]
      type = "Service"
    }
    resources = [
      local.lb_access_logs_arn
    ]
    actions = [
      "s3:GetBucketAcl"
    ]
    condition {
      test     = "StringEquals"
      values   = [local.aws_account]
      variable = "aws:SourceAccount"
    }
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${local.aws_account}:*"]
      variable = "aws:SourceArn"
    }
  }

  statement {
    sid    = "NLBLogDeliveryWritePolicy"
    effect = "Allow"
    principals {
      identifiers = [
        "delivery.logs.amazonaws.com"
      ]
      type = "Service"
    }
    resources = [
      "${local.lb_access_logs_arn}/*"
    ]
    actions = [
      "s3:PutObject"
    ]
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
    condition {
      test     = "StringEquals"
      values   = [local.aws_account]
      variable = "aws:SourceAccount"
    }
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${local.aws_account}:*"]
      variable = "aws:SourceArn"
    }
  }
}
