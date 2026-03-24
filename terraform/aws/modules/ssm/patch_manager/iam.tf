data "aws_iam_policy_document" "patch_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "patch_role" {
  name               = "ssm-${var.name}-patch-role"
  assume_role_policy = data.aws_iam_policy_document.patch_assume_role.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "patch_policy" {
  role       = aws_iam_role.patch_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMMaintenanceWindowRole"
}
