data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

# tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "role_policy" {
  statement {
    sid    = "InstanceSSMEC2Policy"
    effect = "Allow"
    actions = [
      "ssm:ListInstanceAssociations",
      "ssm:PutComplianceItems",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation",
    ]

    resources = [for m in module.nginx : m.ec2_instance_arn]
  }
}

resource "aws_iam_role" "this" {
  name               = "${local.vpc_name}-${local.app_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags               = local.tags
}

resource "aws_iam_instance_profile" "this" {
  name = "${local.vpc_name}-${local.app_name}-instance-profile"
  role = aws_iam_role.this.name
  tags = local.tags
}

resource "aws_iam_role_policy" "this" {
  name   = "${local.vpc_name}-${local.app_name}-role-policy"
  role   = aws_iam_role.this.name
  policy = data.aws_iam_policy_document.role_policy.json
}
