output "ansible_ssm_s3_bucket_name" {
  description = "S3 bucket for Ansible aws_ssm plugin (set ANSIBLE_AWS_SSM_BUCKET_NAME to this value)."
  value       = local.ansible_ssm_s3_bucket_name
}

output "ansible_executor_role_arn" {
  description = "Assume this role for access to the Ansible SSM transfer bucket."
  value       = aws_iam_role.ansible_executor.arn
}

output "ansible_executor_role_name" {
  description = "IAM role name to be assumed by users/roles running ansible-playbook."
  value       = aws_iam_role.ansible_executor.name
}
