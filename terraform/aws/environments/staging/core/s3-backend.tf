module "s3_backend" {
  source                               = "../../../modules/s3/backend"
  environment                          = module.config.environment
  organisation                         = module.config.global.organisation
  business_unit                        = module.config.global.business_unit
  namespace                            = module.config.global.namespace
  tags                                 = module.config.default_tags
  access_log_expiry_days_s3            = 7
  access_log_expiry_days_vpc_flow_logs = 14
  bucket_name_suffix                   = "8f402f"
}
