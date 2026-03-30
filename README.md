# companyx-cloud

Base infrastructure and configuration for ComapnyX AWS workloads (Terraform + Ansible).

## Documentation

| Area | Guide |
|------|--------|
| **Terraform (AWS)** | [terraform/aws/README.md](terraform/aws/README.md) - layout, state model, bootstrap order |
| **Ansible (AWS)** | [ansible/aws/README.md](ansible/aws/README.md) - dynamic inventory, roles, SSM |

Start with the Terraform guide for first-time environment bring-up; use Ansible for host bootstrap and application containers after compute exists.

## AI Collaboration

An `AGENT.md` file is included in this repository to guide AI coding agents on repository structure, architecture intent, and safe change patterns. This helps agents understand the project faster and makes human/AI collaboration more consistent.

## Current Deployment Considerations

### What Was Implemented

- Modular design with wrapper modules to enforce standards consistently (for example, subnet tagging standards that simplify subnet selection via Terraform data sources).
- Pre-commit checks and security tooling are included (`pre-commit`, Trivy scanning, and `detect-secrets`) to reduce the chance of pushing unsafe or unwanted changes.
- Terraform assertions are used to validate VPC CIDR and derived subnet ranges, helping prevent copy/paste mistakes and typos.
- Intentional security exceptions are documented inline using Trivy ignore comments where choices are explicit (for example, intentionally open egress cases).
- Repository hierarchy is designed to scale to multi-cloud without major restructuring.
- Global configuration module centralizes company-wide values (tags, domains, naming patterns), which makes it easier to reuse the same blueprint across business units/subsidiaries by changing shared config.
- Environment-specific config modules (for example `staging/configs`) define shared environment attributes once and expose them via outputs for reuse across stacks.
- Terraform modules are grouped by domain to keep structure clear and maintainable.
- VPC endpoints (for example S3) are used to keep traffic private, reduce internet egress dependency/cost, and improve connectivity performance.
- SSM Patch Manager is included and EC2 instances are tagged for patch groups so patching can be automated and controlled. With proper tuning, maintenance can be performed one instance at a time to preserve availability while keeping systems updated.

### What Can Be Added Later

- Host reusable modules in a dedicated repository and reference them via git tags/commits (or submodules) for clearer module versioning and reuse.
- Add GitHub Actions pipelines for:
  - pre-commit/code-quality/security checks
  - Terraform validation/plan workflows
- Introduce Atlantis (or equivalent) for pull-request-driven Terraform planning/apply execution in GitHub-based workflows.
- Continue improving `AGENT.md` and add scoped AI guidance files for key directories (for example Terraform environment roots and Ansible roots) to make agent behavior more precise as the repo grows.
