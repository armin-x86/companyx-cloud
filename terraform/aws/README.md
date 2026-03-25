# Terraform - AWS

## Layout and conventions

- **`environments/global/configs`** - shared organisation-wide values (names, tags, account IDs, VPN hints, etc.).
- **`environments/<env>/configs`** - environment layer on top of global (e.g. staging): region, VPC definitions, default tags.
- **Root modules** under **`environments/<env>/core`** and **`environments/<env>/services/...`** compose shared **`modules/`** so naming, tagging, and patterns stay consistent (**DRY**), and the same shape can be reused for another business unit or company by changing config, not copying stacks wholesale.

## State model

Each logical part (**core**, **vpc**, **ec2**, **alb**, …) has **its own Terraform state**. That trades some cross-stack coupling for clearer blast radius, ownership, and parallel apply; we accept the usual **ordering and data-source** trade-offs and document the intended bootstrap sequence below.

## Terraform interface

We use **Makefiles** in each root module directory (`make plan`, `make apply`, `make clean`) so everyone runs the same init/plan/apply flow and options across the team.

## Bootstrap sequence (new account / greenfield)

1. **Core (local state first)** - In `environments/<env>/core`, run **`make plan`** then **`make apply`** with backend **not** using the shared S3 remote yet (local state), so the state bucket and lock table (and other core prereqs) can be created.
2. **Point core at S3** - Switch the **core** backend to **S3** and **migrate** state into the bucket you just created.
3. **Wire remote state everywhere else** - Update **backend** blocks (or backend config) for **vpc**, **ec2**, **alb**, and any other roots so they use the same S3 backend pattern.
4. **DNS delegation** - After core creates the **Route 53 hosted zone**, take the zone **NS** records and delegate them at the **root domain** DNS (registrar / parent zone).
5. **VPC** - Run Terraform for the VPC stack (e.g. `environments/<env>/services/.../vpc`): **`make plan`** / **`make apply`**.
6. **EC2** - Run Terraform for compute (e.g. nginx cluster): **`make plan`** / **`make apply`**.
7. **ALB** - Run Terraform for the load balancer: **`make plan`** / **`make apply`**.

**Ansible over SSM** uses an S3 bucket created in **core** (`ansible-ssm` in `s3-simple.tf`). After core apply, run **`terraform output ansible_ssm_s3_bucket_name`** in `environments/<env>/core`, then have your user/role assume **`terraform output ansible_executor_role_arn`** to access that bucket.

Adjust paths for your environment name (`staging`, etc.) and service layout under `services/`.
