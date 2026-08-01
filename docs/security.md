# Security

The container runs as UID/GID 10001, drops all capabilities, uses a read-only root filesystem and does not receive a Kubernetes API token. NetworkPolicies default-deny traffic and allow only approved ingress, DNS and workload-to-workload egress.

CI uses current-source Gitleaks, Semgrep, Trivy and an SPDX SBOM artifact. GitHub Advanced Security is not required.

Registry credentials are not committed. The Deployment uses a ServiceAccount referencing `ghcr-pull-secret`; TuskerBlueprint stores the source credential in `platform-secrets/ghcr-pull-credentials` and each approved workload declares an `ExternalSecret` that materializes it locally. Argo CD private-repository credentials are stored in its namespace as a `repo-creds` Secret.


Kubernetes Secret data is not a substitute for encryption at rest. Production clusters should enable API-server Secret encryption, apply least-privilege RBAC to `platform-secrets`, use a dedicated GHCR read-only machine credential, and rotate the source Secret regularly.
