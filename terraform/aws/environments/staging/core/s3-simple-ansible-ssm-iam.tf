# IAM for the machine running Ansible:
# 1) caller principal assumes ansible-executor-role
# 2) that role has permissions for the ansible-ssm transfer bucket
# 3) bucket policy also allows only that role ARN as principal

locals {
  ansible_ssm_s3_bucket_name  = "${module.config.global.organisation}-${module.config.global.business_unit}-ansible-ssm-${module.config.environment}"
  ansible_executor_role_name  = "ansible-executor-role-${module.config.environment}"
  this_account_root_principal = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
}

data "aws_iam_policy_document" "ansible_executor_assume_role" {
  statement {
    sid     = "AllowTrustedPrincipalsToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [local.this_account_root_principal]
    }
  }
}

resource "aws_iam_role" "ansible_executor" {
  name               = local.ansible_executor_role_name
  assume_role_policy = data.aws_iam_policy_document.ansible_executor_assume_role.json
  tags               = module.config.default_tags
}

data "aws_iam_policy_document" "ansible_executor_s3_access" {
  statement {
    sid    = "ListAndLocateBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = [
      "arn:aws:s3:::${local.ansible_ssm_s3_bucket_name}",
    ]
  }

  statement {
    sid    = "ObjectTransfer"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
      "s3:ListBucketMultipartUploads",
    ]
    resources = [
      "arn:aws:s3:::${local.ansible_ssm_s3_bucket_name}/*",
    ]
  }
}

resource "aws_iam_role_policy" "ansible_executor_s3_access" {
  name   = "${module.config.global.organisation}-ansible-ssm-transfer-${module.config.environment}"
  role   = aws_iam_role.ansible_executor.name
  policy = data.aws_iam_policy_document.ansible_executor_s3_access.json
}

data "aws_iam_policy_document" "ansible_ssm_bucket_access" {
  statement {
    sid    = "AllowAnsibleExecutorRoleListAndLocation"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.ansible_executor.arn]
    }
    resources = [
      "arn:aws:s3:::${local.ansible_ssm_s3_bucket_name}",
    ]
  }

  statement {
    sid    = "AllowAnsibleExecutorRoleObjectTransfer"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
      "s3:ListBucketMultipartUploads",
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.ansible_executor.arn]
    }
    resources = [
      "arn:aws:s3:::${local.ansible_ssm_s3_bucket_name}/*",
    ]
  }
}
