# `general` role

Amazon Linux baseline bootstrap with no application-specific services.

| Step | File                | Purpose                                  | Tags                  |
|------|---------------------|------------------------------------------|-----------------------|
| 10   | `10_os_update.yml`  | OS package update via `package` (yum/dnf) | `general`, `os`       |
| 20   | `20_ssm_agent.yml`  | Ensure `amazon-ssm-agent` is installed/up | `general`, `ssm`      |
| 30   | `30_podman.yml`     | Install Podman runtime                    | `general`, `podman`, `container` |
