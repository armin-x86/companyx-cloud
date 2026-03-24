data "aws_vpc" "app_euw_1" {
  cidr_block = module.config.vpc.app-euw-1.cidr_block
}

data "aws_subnets" "app_euw_1_public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.app_euw_1.id]
  }

  tags = {
    "${module.config.global.namespace}/subnet_type" = "public"
  }
}

data "aws_acm_certificate" "phrase" {
  domain    = "*.${module.config.global.root_domain}"
  statuses  = ["ISSUED"]
  types     = ["AMAZON_ISSUED"]
  key_types = ["EC_prime256v1"]
}

data "aws_route53_zone" "phrase" {
  name = module.config.r53_zone
}

data "aws_instances" "nginx" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.app_euw_1.id]
  }

  filter {
    name   = "tag:${module.config.global.namespace}/application"
    values = ["phrase-lb"]
  }
}
