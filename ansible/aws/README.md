# Ansible — AWS (SSM + EC2 dynamic inventory)

Private-subnet EC2 instances have **no public IP** here; Ansible uses **`amazon.aws.aws_ssm`** (Session Manager + S3 for module transfer), not SSH.

## Role model

- We use a **`general`** role for generic host bootstrap (OS updates, SSM agent, Podman/runtime prerequisites).
- We use a dedicated **`nginx`** role only for nginx-related hosts and workload configuration.

## Inventory model

- We use **dynamic inventory** with `amazon.aws.aws_ec2`.
- The inventory creates a host group named **`application_phrase_lb`** from EC2 tags.
- **`application_phrase_lb`** includes all nginx EC2 machines and is targeted by the nginx play.
