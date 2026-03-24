run "validate_vpc_cidr_in_range" {
  command = plan

  assert {
    condition = alltrue([
      for vpc_name, vpc_data in local.vpc :
      can(cidrhost(module.global.ip_cidr_ranges.stg, 1)) &&
      can(cidrhost(vpc_data.cidr_block, 1)) &&
      tonumber(join("", split(".", cidrhost(vpc_data.cidr_block, 1)))) >= tonumber(join("", split(".", cidrhost(module.global.ip_cidr_ranges.prd, 1)))) &&
      tonumber(join("", split(".", cidrhost(vpc_data.cidr_block, -1)))) <= tonumber(join("", split(".", cidrhost(module.global.ip_cidr_ranges.prd, -1))))
    ])
    error_message = "One or more VPC CIDR blocks are NOT within the CIDR range (${module.global.ip_cidr_ranges.stg})"
  }
}
