variable "namespace" {
  description = "The namespace for tagging"
  type        = string
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "operating_system" {
  description = "Operating system type: 'UBUNTU' or 'AMAZON_LINUX_2'"
  type        = string
}

variable "patch_group" {
  description = "Patch group tag to identify instances"
  type        = string
}

# Must match the same tag key on EC2 instances (SSM maintenance window target uses tag:<this>).
variable "instance_patch_tag_key" {
  description = "EC2 instance tag key for Patch Manager grouping (value must equal patch_group)"
  type        = string
  default     = "keyrock.io/patch-group"
}

variable "patch_baseline_approval_rules" {
  description = <<EOT
    A set of rules used to include patches in the baseline. Up to 10 approval rules can be specified.
    Each `approval_rule` block requires the fields documented below (unless marked optional).
    `approve_after_days` and `approve_until_date` conflict, do not set both in the same `approval_rule`.

    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_patch_baseline#approval_rule-block for full details.
  EOT
  type = list(object({
    approve_after_days  = optional(number)
    approve_until_date  = optional(string)
    compliance_level    = string
    enable_non_security = bool
    patch_baseline_filters = list(object({
      key    = string
      values = list(string)
    }))
  }))

  default = [
    {
      approve_after_days  = 7
      compliance_level    = "HIGH"
      enable_non_security = true
      patch_baseline_filters = [
        {
          key    = "PRODUCT"
          values = ["AmazonLinux2023"]
        },
        {
          key    = "CLASSIFICATION"
          values = ["Security", "Bugfix", "Recommended"]
        },
        {
          key    = "SEVERITY"
          values = ["Critical", "Important", "Medium"]
        }
      ]
    }
  ]
}

variable "maintenance_window_scan_schedule" {
  description = "Maintenance window schedule in cron format"
  type        = string
  default     = "cron(0 2 * * ? *)" # Daily at 02:00 UTC
}

variable "maintenance_window_scan_duration" {
  description = "Maintenance window duration in hours"
  type        = number
  default     = 2
}

variable "maintenance_window_scan_cutoff" {
  description = "Maintenance window cutoff in hours"
  type        = number
  default     = 1
}

variable "maintenance_window_install_schedule" {
  description = "Maintenance window schedule in cron format"
  type        = string
  default     = "cron(0 4 * * ? *)" # Daily at 04:00 UTC
}

variable "maintenance_window_install_duration" {
  description = "Maintenance window duration in hours"
  type        = number
  default     = 2
}

variable "maintenance_window_install_cutoff" {
  description = "Maintenance window cutoff in hours"
  type        = number
  default     = 1
}

variable "task_scan_priority" {
  description = "The priority of the task in the SSM Maintenance Window, the lower the number the higher the priority. Tasks that are not specified in a Maintenance Window are not scheduled."
  type        = number
  default     = 1
}

variable "task_install_priority" {
  description = "The priority of the task in the SSM Maintenance Window, the lower the number the higher the priority. Tasks that are not specified in a Maintenance Window are not scheduled."
  type        = number
  default     = 1
}

variable "task_max_concurrency" {
  description = "The maximum number of targets this task can be run for in parallel."
  type        = number
  default     = 3
}

variable "task_max_errors" {
  description = "The maximum number of errors allowed before this task stops being scheduled."
  type        = number
  default     = 1
}

variable "reboot_option" {
  description = "When you choose the RebootIfNeeded option, the instance is rebooted if Patch Manager installed new patches, or if it detected any patches with a status of INSTALLED_PENDING_REBOOT during the Install operation. Possible values : RebootIfNeeded, NoReboot"
  type        = string
  default     = "RebootIfNeeded"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
