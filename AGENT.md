# AGENT.md

## Purpose

This repository provisions and configures AWS infrastructure for `phrase-cloud` using Terraform and Ansible.

The intended delivery flow is:

1. Provision shared and environment-specific AWS infrastructure with Terraform
2. Create networking first (VPC and related dependencies)
3. Provision EC2 compute into that network
4. Provision ALB in front of the EC2 workload
5. Configure EC2 instances with Ansible using dynamic AWS inventory
6. Run quality and security checks through pre-commit and Trivy before accepting changes

This file instructs coding agents how to work safely and consistently in this repository.

---

## Repository Layout

```text
phrase-cloud/
├── AGENT.md
├── README.md
├── ansible/
│   └── aws/
│       ├── README.md
│       ├── ansible.cfg
│       ├── inventory/
│       │   ├── aws_ec2.yml
│       │   ├── group_vars/
│       │   │   ├── all.yaml
│       │   │   ├── application_phrase_lb.yaml
│       │   │   └── aws_ec2.yml
│       │   └── localhost.yml
│       ├── main.yaml
│       ├── requirements.yml
│       └── roles/
│           ├── general/
│           └── nginx/
├── snippets/
│   └── aws/
│       └── vpc/
│           └── default-vpcs-deletion.sh
├── terraform/
│   └── aws/
│       ├── README.md
│       ├── environments/
│       │   ├── global/
│       │   │   └── configs/
│       │   └── staging/
│       │       ├── configs/
│       │       ├── core/
│       │       └── services/
│       │           └── app-euw-1/
│       │               ├── alb/
│       │               ├── ec2/
│       │               │   └── nginxcluster/
│       │               └── vpc/
│       └── modules/
│           ├── ec2/
│           ├── lb/
│           │   └── alb/
│           ├── r53/
│           ├── s3/
│           │   ├── backend/
│           │   └── simple/
│           ├── secrets/
│           ├── ssm/
│           │   └── patch_manager/
│           └── vpc/
│               ├── endpoints/
│               │   └── s3/
│               ├── peering/
│               └── simple/
└── trivy.yaml
```

---

## Architecture Intent

### Provisioning order

Agents should preserve this dependency order:

1. `terraform/aws/environments/*/core`
2. `terraform/aws/environments/*/services/*/vpc`
3. `terraform/aws/environments/*/services/*/ec2/*`
4. `terraform/aws/environments/*/services/*/alb`
5. `ansible/aws/*` for post-provisioning host configuration

### Environment split

This repository separates concerns into:

- `terraform/aws/modules/`
  - reusable wrapper modules owned by this repo
- `terraform/aws/environments/global/configs/`
  - global/shared configuration
- `terraform/aws/environments/staging/configs/`
  - staging-level configuration and tests
- `terraform/aws/environments/staging/core/`
  - foundational shared resources for staging
- `terraform/aws/environments/staging/services/app-euw-1/vpc/`
  - service-level network layer
- `terraform/aws/environments/staging/services/app-euw-1/ec2/nginxcluster/`
  - compute layer for nginx-backed application nodes
- `terraform/aws/environments/staging/services/app-euw-1/alb/`
  - ingress layer in front of EC2

Agents must keep this layering intact.

---

## Terraform Design Rules

### Module Strategy

This repository uses wrapper modules under:

- `terraform/aws/modules/ec2`
- `terraform/aws/modules/vpc/simple`
- `terraform/aws/modules/s3/backend`
- `terraform/aws/modules/s3/simple`
- `terraform/aws/modules/r53`

Agents must prefer extending wrapper modules over scattering direct upstream community-module usage throughout environment stacks.

### Wrapper module expectations

- Expose only the inputs needed by this platform
- Keep defaults opinionated and secure
- Validate input combinations explicitly
- Reflect upstream module behavior intentionally
- Document migrations when upstream module versions change behavior

### Strong typing

Prefer exact Terraform types over `any` whenever practical.

Allowed exceptions:

- temporary migration shims
- compatibility bridges while refactoring wrapper interfaces

Do not introduce new `type = any` variables unless there is a strong reason.

---

## Terraform File Responsibilities

Within Terraform directories, keep this separation where possible:

- `main.tf` for resources and module calls
- `variables.tf` for inputs
- `outputs.tf` for outputs
- `locals.tf` for derived values
- `versions.tf` for Terraform and provider constraints
- `providers.tf` for provider configuration
- `data.tf` for data sources

---

## Networking Rules

### NAT Gateway behavior

- `single_nat_gateway = true` → exactly 1 NAT
- `one_nat_gateway_per_az = true` → NAT per AZ
- both false → default (derived from subnet lengths)

If reusing NAT EIPs:
- validate exact count
- do not allow mismatches

---

### Subnets

- Separate public/private clearly
- EC2 should be private by default
- ALB uses public subnets

---

### Flow Logs

- Prefer S3
- Prefer parquet for Athena usage

---

## EC2 Rules

### OS

- Default: Amazon Linux 2023

---

### Storage

- root_block_device → root disk
- extra EBS → additional volumes

---

### Access

- Prefer SSM Session Manager
- Avoid SSH exposure unless required

---

### Security Groups

- Least privilege
- No broad open ingress

---

### Bootstrap

- Keep `user_data.sh` minimal
- Do not replace Ansible with user_data

---

## ALB Rules

- Depends on EC2 readiness
- Explicit listeners and health checks
- Minimal ingress
- Clear target group configuration

---

## S3 / Athena / Cost

- S3 = storage
- Glue = schema
- Athena = query engine

Typical pattern:
- cost-report bucket → input
- athena bucket → query output

---

## Secrets / SSM

- Never hardcode secrets
- Use SSM/parameters
- Mark outputs sensitive
- For Ansible over SSM, keep using the dedicated S3 transfer bucket and IAM executor-role model from `environments/staging/core`.

---

## Ansible Guidance

Current structure:

```text
ansible/aws/
├── inventory/
├── roles/
│   ├── general/
│   └── nginx/
├── main.yaml
```

Rules:

- Use dynamic AWS inventory
- Use `roles/general` for generic host bootstrap concerns
- Use `roles/nginx` only for nginx-specific hosts/configuration
- Keep dynamic inventory group naming stable (for example `application_phrase_lb` for nginx EC2 hosts)
- For SSM connection via `amazon.aws.aws_ssm`, keep `ansible_host` mapped to instance id in inventory compose
- Keep roles idempotent
- Avoid hardcoding values

---

## Quality Gates

### Pre-commit

- terraform fmt
- terraform validate
- linting / yaml checks

---

### Trivy

- enforce secure defaults
- encryption required
- no unnecessary exposure

---

## Change Rules

1. Preserve layering: core → vpc → ec2 → alb → ansible
2. Prefer wrapper modules
3. Keep variables typed and validated
4. Avoid broad permissions
5. No hardcoded secrets
6. Keep tagging consistent
7. Maintain readability
8. Align with upstream modules
9. Validate inputs
10. Be cost-aware

---

## Summary

This repo is:

- Terraform-first
- Wrapper-module driven
- Security-conscious
- Cost-aware
- Pre-commit + Trivy enforced
- Ansible-managed

Agents must prioritize:

- safety
- clarity
- correctness
- maintainability
