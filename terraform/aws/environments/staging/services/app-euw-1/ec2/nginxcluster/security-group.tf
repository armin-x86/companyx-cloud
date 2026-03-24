locals {
  ports = {
    nginx = 80
    ssh   = 22
  }

  ec2_security_group_cidr_blocks = flatten([
    [for port_key, port_value in local.ports : {
      from_port   = port_value
      to_port     = port_value
      protocol    = "tcp"
      description = "Access from ALB to ${port_key} port"
      cidr_blocks = data.aws_vpc.app_euw_1.cidr_block
    }]
  ])
}

# trivy:ignore:avd-aws-0104
# tfsec:ignore:aws-ec2-no-public-egress-sgr
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name            = "${module.config.vpc.app-euw-1.name}-${local.app_name}"
  use_name_prefix = false
  description     = "Phrase Lab env security group for ${local.app_name}"
  vpc_id          = data.aws_vpc.app_euw_1.id

  # ingress
  ingress_with_cidr_blocks = concat(local.ec2_security_group_cidr_blocks) # Room for possible future rules with different CIDR blocks

  # egress
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = local.tags
}
