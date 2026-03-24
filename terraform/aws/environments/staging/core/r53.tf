# Creating our R53 zone in AWS
module "r53" {
  source        = "../../../modules/r53"
  business_unit = module.config.global.business_unit
  environment   = module.config.environment
  namespace     = module.config.global.namespace
  organisation  = module.config.global.organisation
  zone_name     = module.config.r53_zone
}
