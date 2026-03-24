variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "listeners" {
  description = "List of maps defining the ALB listeners"
  type        = any
}

variable "target_groups" {
  description = "List of maps defining the ALB target groups"
  type        = any
}

variable "additional_target_group_attachments" {
  description = "Map of extra target attachments for terraform-aws-modules/alb (e.g. multiple EC2 instances per target group)"
  type        = any
  default     = null
}

# Networking Variables
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnets" {
  description = "List of subnets to place the ALB"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security groups to assign to the ALB"
  type        = list(string)
}

#Loadbalancer attributes
variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled"
  type        = bool
  default     = true
}

variable "enable_cross_zone_load_balancing" {
  description = "If true, cross-zone load balancing of the load balancer will be enabled"
  type        = bool
  default     = true
}

variable "internal" {
  description = "If true, the ALB will be internal"
  type        = bool
  default     = true # Default to internal for security
}

variable "preserve_host_header" {
  description = "Host header preservation setting"
  type        = bool
  default     = false
}

variable "logs_s3_bucket_id" {
  description = "S3 bucket for ALB logs"
  type        = string
  default     = ""
}

# Tags
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}
