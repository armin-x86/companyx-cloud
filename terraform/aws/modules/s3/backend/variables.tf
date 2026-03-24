variable "organisation" {
  description = "The name of organisation"
  type        = string
}

variable "business_unit" {
  description = "The name of business unit"
  type        = string
}

variable "namespace" {
  description = "The namespace for tagging"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "access_log_expiry_days_s3" {
  description = "The days to keep the access logs"
  type        = number
  default     = 90
}

variable "access_log_expiry_days_vpc_flow_logs" {
  description = "The days to keep the access logs"
  type        = number
  default     = 90
}

variable "tags" {
  description = "The tags for the bucket"
  type        = any
  default     = {}
}

variable "bucket_name_suffix" {
  description = "Optional Suffix for the bucket name"
  type        = string
  default     = ""
}
