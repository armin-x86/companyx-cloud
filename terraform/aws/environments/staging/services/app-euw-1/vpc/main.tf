module "config" {
  source = "../../../configs"
}

module "vpc" {
  source = "../../../../../modules/vpc/simple"

  namespace              = module.config.global.namespace
  name                   = module.config.vpc.app-euw-1.name
  cidr_block             = module.config.vpc.app-euw-1.cidr_block
  private_subnet_cidrs   = module.config.vpc.app-euw-1.private_subnet_cidrs
  public_subnet_cidrs    = module.config.vpc.app-euw-1.public_subnet_cidrs
  single_nat_gateway     = try(module.config.vpc.app-euw-1.single_nat_gateway, true) ? true : false
  one_nat_gateway_per_az = try(module.config.vpc.app-euw-1.single_nat_gateway, false) ? false : true
  reuse_nat_ips          = false
  availability_zones     = module.config.vpc.app-euw-1.availability_zones
  tags                   = module.config.default_tags
  vpc_flow_log_enabled   = true
  vpc_flow_logs_bucket   = "${module.config.global.organisation}-${module.config.global.business_unit}-vpc-flow-logs-${module.config.environment}"
}

module "vpc_endpoints_s3" {
  source = "../../../../../modules/vpc/endpoints/s3"

  create              = true
  aws_account_id      = module.config.global.aws_accounts.stg
  organisation        = module.config.global.organisation
  business_unit       = module.config.global.business_unit
  namespace           = module.config.global.namespace
  vpc_id              = module.vpc.vpc_id
  vpc_name            = module.config.vpc.app-ap-1.name
  vpc_route_table_ids = concat(module.vpc.private_route_table_ids, module.vpc.public_route_table_ids)
  tags                = module.config.default_tags
}
