# SCAN
resource "aws_ssm_maintenance_window" "patch_scan" {
  name                       = "${var.name}-patch-scan"
  description                = "Patch management scan window for ${var.name}"
  schedule                   = var.maintenance_window_scan_schedule
  duration                   = var.maintenance_window_scan_duration
  cutoff                     = var.maintenance_window_scan_cutoff
  allow_unassociated_targets = true
  tags                       = local.tags
}

resource "aws_ssm_maintenance_window_target" "target_scan" {
  window_id     = aws_ssm_maintenance_window.patch_scan.id
  name          = "${var.name}-scan-patch-targets"
  description   = "The resource targets to register to scan with the maintenance window. In this case, we just use the instances we created."
  resource_type = "INSTANCE"

  targets {
    key    = "tag:${var.instance_patch_tag_key}"
    values = [var.patch_group]
  }
}

# https://registry.terraform.io/providers/-/aws/5.67.0/docs/resources/ssm_maintenance_window_task
resource "aws_ssm_maintenance_window_task" "patch_scan_task" {
  window_id        = aws_ssm_maintenance_window.patch_scan.id
  name             = "${var.name}-patch-scan-task"
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-RunPatchBaseline"
  description      = "Runs a scan operation for ${var.name}"
  service_role_arn = aws_iam_role.patch_role.arn
  priority         = var.task_scan_priority
  max_concurrency  = var.task_max_concurrency
  max_errors       = var.task_max_errors

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.target_scan.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Operation"
        values = ["Scan"]
      }
      parameter {
        name   = "RebootOption"
        values = [var.reboot_option]
      }
    }
  }
}

# INSTALL
resource "aws_ssm_maintenance_window" "patch_install" {
  name                       = "${var.name}-patch-install"
  description                = "Patch management install window for ${var.name}"
  schedule                   = var.maintenance_window_install_schedule
  duration                   = var.maintenance_window_install_duration
  cutoff                     = var.maintenance_window_install_cutoff
  allow_unassociated_targets = true
  tags                       = local.tags
}

resource "aws_ssm_maintenance_window_target" "target_install" {
  window_id     = aws_ssm_maintenance_window.patch_install.id
  name          = "${var.name}-install-patch-targets"
  description   = "The resource targets to register to install with the maintenance window. In this case, we just use the instances we created."
  resource_type = "INSTANCE"

  targets {
    key    = "tag:${var.instance_patch_tag_key}"
    values = [var.patch_group]
  }
}

# https://registry.terraform.io/providers/-/aws/5.67.0/docs/resources/ssm_maintenance_window_task
resource "aws_ssm_maintenance_window_task" "patch_install_task" {
  window_id        = aws_ssm_maintenance_window.patch_install.id
  name             = "${var.name}-patch-install-task"
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-RunPatchBaseline"
  description      = "Runs a patch operation for ${var.name}"
  service_role_arn = aws_iam_role.patch_role.arn
  priority         = var.task_install_priority
  max_concurrency  = var.task_max_concurrency
  max_errors       = var.task_max_errors
  # cutoff_behavior = "CONTINUE_TASK" # CONTINUE_TASK or CANCEL_TASK

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.target_install.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Operation"
        values = ["Install"]
      }
      parameter {
        name   = "RebootOption"
        values = [var.reboot_option]
      }
    }
  }
}
