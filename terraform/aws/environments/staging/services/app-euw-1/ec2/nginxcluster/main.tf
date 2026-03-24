module "config" {
  source = "../../../../configs"
}

locals {
  app_name           = "phrase-lb"
  vpc_name           = module.config.vpc.app-euw-1.name
  private_subnet_ids = sort(data.aws_subnets.app_euw_1_private.ids)
  key_name           = "phrase-general-key" # This is a test scenario. In real production we don't use keys and instead we integrate with SSM.

  patch_group = "al2023"
  tags = merge({
    "${module.config.global.namespace}/application" = local.app_name
    "${module.config.global.namespace}/patch-group" = local.patch_group
  }, module.config.default_tags)
}

module "nginx" {
  source = "../../../../../../modules/ec2"
  for_each = {
    for idx, subnet_id in local.private_subnet_ids :
    "${local.app_name}-${idx + 1}" => subnet_id
  }
  instance_name               = each.key
  subnet_id                   = each.value
  vpc_security_group_ids      = [module.security_group.security_group_id]
  key_name                    = local.key_name
  user_data                   = file("${path.cwd}/user_data.sh")
  iam_instance_profile        = aws_iam_instance_profile.this.name
  create_iam_instance_profile = false
  root_block_device = [{
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }]
  metadata_options = {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
  }
  tags = local.tags
}
