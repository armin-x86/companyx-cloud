module "global" {
  source = "../../global/configs"
}

locals {
  environment       = "staging"
  aws_region        = "eu-west-1"
  secrets_namespace = "${module.global.secrets_namespace}-stg"
  r53_zone          = module.global.root_domain
  vpc = {
    app-euw-1 = {
      name = "app-euw-1"
      # 10.100.200.0 - 10.100.203.255
      # 1024 IPs
      cidr_block = "10.100.200.0/22"
      private_subnet_cidrs = [
        "10.100.200.0/24",  # 256
        "10.100.201.0/25",  # 128
        "10.100.201.128/25" # 128
      ]
      public_subnet_cidrs = [
        "10.100.202.0/24",  # 256
        "10.100.203.0/25",  # 128
        "10.100.203.128/25" # 128
      ]
      availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
      single_nat_gateway = false
    }
  }
}
