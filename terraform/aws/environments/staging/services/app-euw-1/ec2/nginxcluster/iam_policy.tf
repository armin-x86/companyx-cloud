data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "instance_ssm" {
  statement {
    sid    = "InstanceSSMEC2Policy"
    effect = "Allow"
    actions = [
      "ssm:ListInstanceAssociations",
      "ssm:PutComplianceItems",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation",
    ]

    resources = [
      "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/*",
    ]
  }
}

resource "aws_iam_policy" "instance_ssm" {
  name   = "${local.vpc_name}-${local.app_name}-instance-ssm"
  policy = data.aws_iam_policy_document.instance_ssm.json
  tags   = local.tags
}
