# Security

The container runs as UID/GID 10001, drops all capabilities, uses a read-only root filesystem and does not receive a Kubernetes API token. NetworkPolicies default-deny traffic and allow only approved ingress, DNS and workload-to-workload egress.

CI uses current-source Gitleaks, Semgrep, Trivy and an SPDX SBOM artifact. GitHub Advanced Security is not required.
