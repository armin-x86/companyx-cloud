variable "namespace" {
  description = "The namespace for tagging"
  type        = string
}

variable "name" {
  description = "The unique vpc name to assign to the resources"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_flow_log_enabled" {
  description = "Enable/Disable flow logs"
  type        = bool
  default     = true
}

variable "vpc_flow_logs_bucket" {
  description = "The S3 bucket of vpc flow logs"
  type        = string
  default     = ""
  validation {
    condition     = length(var.vpc_flow_logs_bucket) == 0 || (length(var.vpc_flow_logs_bucket) > 0 && var.vpc_flow_log_enabled)
    error_message = "The vpc_flow_logs_bucket is required if vpc_flow_log_enabled true."
  }
}

variable "private_subnet_cidrs" {
  description = "The list of CIDRs for cluster private subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "The list of CIDRs for cluster public subnets"
  type        = list(string)
}

variable "public_subnet_tags" {
  description = "The tags for public subnets"
  type        = map(string)
  default     = null
}

variable "private_subnet_tags" {
  description = "The tags for private subnets"
  type        = map(string)
  default     = null
}

variable "availability_zones" {
  description = "Availability zones to place subnets"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "single_nat_gateway_enabled" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az_enabled" {
  description = "This has no effect if single_nat_gateway is set to true. Set to True so you will have on NGW per AZ. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`"
  type        = bool
  default     = true
}

variable "reuse_nat_ips_enabled" {
  description = "Enable/Disable using an already created EIP for NGW. If set to True, 'external_nat_ip_ids' variable should be passed down to the module"
  type        = bool
  default     = false
}

variable "external_nat_ip_ids_list" {
  description = "List of EIP IDs to be assigned to the NAT Gateways if reuse_nat_ips_enabled is set to true"
  type        = list(string)
  default     = []

  # There is a 3rd situation where both single and per_az are false, then community module will calculate total
  # length of all subnets and will create NGW using that length which is not covered in my code here.
  validation {
    condition = (
      !var.reuse_nat_ips_enabled ||
      (
        var.single_nat_gateway_enabled &&
        length(var.external_nat_ip_ids_list) == 1
      ) ||
      (
        var.one_nat_gateway_per_az_enabled &&
        length(var.external_nat_ip_ids_list) == length(var.availability_zones)
      )
    )

    error_message = "When reuse_nat_ips_enabled is true, external_nat_ip_ids_list must match the NAT Gateway mode: exactly 1 item for single_nat_gateway, exactly one item per AZ for one_nat_gateway_per_az"
  }
}
