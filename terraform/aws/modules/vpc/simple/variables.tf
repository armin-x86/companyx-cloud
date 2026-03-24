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
  default     = false
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

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = true
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`"
  type        = bool
  default     = false
}

variable "reuse_nat_ips" {
  description = "Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable"
  type        = bool
  default     = false
}

variable "external_nat_ip_ids_list" {
  description = "List of EIP allocation IDs to assign to NAT Gateways when reuse_nat_ips is true"
  type        = list(string)
  default     = []

  validation {
    condition = (
      !var.reuse_nat_ips ||
      (
        var.single_nat_gateway &&
        length(var.external_nat_ip_ids_list) == 1
      ) ||
      (
        !var.single_nat_gateway &&
        var.one_nat_gateway_per_az &&
        length(var.external_nat_ip_ids_list) == length(var.availability_zones)
      )
    )

    error_message = "When reuse_nat_ips is true, external_nat_ip_ids_list must contain exactly 1 EIP for single_nat_gateway, one EIP per AZ for one_nat_gateway_per_az"
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
