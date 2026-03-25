locals {
  ports = {
    https = 443
    http  = 80
  }
}

# trivy:ignore:avd-aws-0104
module "app_euw_1_alb_vpn_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name            = "${module.config.vpc.app-euw-1.name}-alb-vpn-sg"
  use_name_prefix = false
  description     = "VPN / ZTNA to ${module.config.vpc.app-euw-1.name}-alb-external"
  vpc_id          = data.aws_vpc.app_euw_1.id

  ingress_with_cidr_blocks = flatten([
    for port_key, port_value in local.ports : [
      for vpn_key, vpn_value in module.config.global.vpn : {
        from_port   = port_value
        to_port     = port_value
        protocol    = "tcp"
        description = vpn_value.description
        cidr_blocks = vpn_value.public_cidr_blocks
      }
    ]
  ])

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = module.config.vpc.app-euw-1.cidr_block
    }
  ]
  tags = local.tags
}

# trivy:ignore:avd-aws-0104
module "app_euw_1_alb_internal_clients_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name            = "${module.config.vpc.app-euw-1.name}-alb-internal-clients-sg"
  use_name_prefix = false
  description     = "Internal clients to ${module.config.vpc.app-euw-1.name}-alb-external"
  vpc_id          = data.aws_vpc.app_euw_1.id

  ingress_with_cidr_blocks = [
    for port_key, port_value in local.ports : {
      from_port   = port_value
      to_port     = port_value
      protocol    = "tcp"
      description = "Internal VPC access to ${port_key}"
      cidr_blocks = module.config.vpc.app-euw-1.cidr_block
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = module.config.vpc.app-euw-1.cidr_block
    }
  ]
  tags = local.tags
}

# Public internet HTTPS (staging). we may narrow this down for production.
# trivy:ignore:avd-aws-0104
# tfsec:ignore:aws-ec2-no-public-ingress-sgr
module "app_euw_1_alb_external_clients_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name            = "${module.config.vpc.app-euw-1.name}-alb-external-clients-sg"
  use_name_prefix = false
  description     = "External public clients to ${module.config.vpc.app-euw-1.name}-alb-external"
  vpc_id          = data.aws_vpc.app_euw_1.id

  ingress_with_cidr_blocks = [
    {
      from_port   = local.ports.https
      to_port     = local.ports.https
      protocol    = "tcp"
      description = "Public HTTPS"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = module.config.vpc.app-euw-1.cidr_block
    }
  ]
  tags = local.tags
}
