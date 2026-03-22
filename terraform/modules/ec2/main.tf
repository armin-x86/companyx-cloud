module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name                   = var.instance_name
  create                 = var.create_instance
  instance_type          = var.instance_type
  ami                    = var.ami
  key_name               = var.key_name # we better never pass key_name as we prefer to rely on SSM
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.subnet_id
  create_eip             = var.eip

  root_block_device = var.root_block_device
  ebs_block_device  = var.ebs_block_device

  create_iam_instance_profile = var.create_iam_instance_profile
  iam_role_use_name_prefix    = false
  iam_instance_profile        = var.iam_instance_profile
  iam_role_name               = "${var.instance_name}${length(var.iam_role_name_suffix) > 0 ? "-${var.iam_role_name_suffix}" : ""}-role"
  iam_role_path               = "/"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  # Instance User Data
  user_data = var.user_data

  # AMI
  ignore_ami_changes = var.ignore_ami_changes

  # Instance Metadata
  metadata_options = var.metadata_options

  tags = var.tags

  volume_tags = var.tags

  eip_tags = {
    Name = var.instance_name
  }

  iam_role_tags = var.tags
}
