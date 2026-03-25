# Infra Terraform Core Components

## Route53
- We use public zone
- You need to add/update the core Route53 record after creation of zone
- We need a NS record in ateimouri.com (Change it with your domain) so this public zone will be resolved for ACM and other services
- Since it is a public zone setup, we don't need to register the VPCs for the zone

## S3
### S3 Backend
- The essential setup for S3 access logs and access policies
- The essential VPC flow logs for all regions

### S3 Simple
- General S3 buckets setup and their policies with a set of naming conventions
- All bucket has life cycle policies configure however the applications needs to have Storage Class set to INTELLIGENT_TIERING for best outcome
- Excessive storage class movement will cost us more therefore, always use INTELLIGENT_TIERING as default storage class from application themselves

#### Ansible `aws_ssm` transfer bucket (`ansible-ssm`)
- Private bucket (SSE-S3), **versioning suspended**, **access logging disabled** for this key (no dependency on the org access-logs bucket for logging config).
- **7-day expiration** rule for abandoned temp objects (the plugin normally deletes after each run).
- **`aws_iam_role.ansible_executor`**: dedicated role for Ansible execution. It has S3 transfer permissions and the bucket policy only allows this role ARN as principal.
- Trusted principals in this AWS account can assume that role (via role trust policy), so users/automation must be granted `sts:AssumeRole` for it.
- After apply: `terraform output ansible_ssm_s3_bucket_name` → set **`ANSIBLE_AWS_SSM_BUCKET_NAME`** (see `ansible/aws/README.md`).

## Secrets Manager
- Creates essential secrets items without the entries
