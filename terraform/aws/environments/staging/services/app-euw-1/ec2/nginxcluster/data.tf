data "aws_vpc" "app_euw_1" {
  cidr_block = module.config.vpc.app-euw-1.cidr_block
}


data "aws_subnets" "app_euw_1_private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.app_euw_1.id]
  }

  tags = {
    "${module.config.global.namespace}/subnet_type" = "private"
  }
}
