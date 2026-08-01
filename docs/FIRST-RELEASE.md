# First immutable release

Use this procedure immediately after Backstage creates the application repository.

1. Confirm the platform owner has configured Kubernetes GitHub credentials with `scripts/backstage/configure-github-platform-secret.sh` in the TuskerBlueprint repository.
2. Open **Actions → Service CI and Release** and inspect the initial run.
3. Confirm formatting, type checks, tests, coverage, current-source Gitleaks, Semgrep, Trivy and SBOM generation pass.
4. Confirm the workflow publishes `ghcr.io/<owner>/<repository>:<full-commit-sha>` and verifies the authenticated manifest.
5. Review the release pull request. Only `deploy/overlays/development/kustomization.yaml` may change, and the new tag must be the full commit SHA.
6. GitHub may require a write user to approve workflows on a pull request created by `GITHUB_TOKEN`. Review the change and approve the workflows.
7. Merge the service release pull request.
8. Merge the separate TuskerBlueprint onboarding pull request that adds `gitops/generated-workloads/<service>/application.yaml`.
9. Confirm the target namespace has `ghcr-pull-secret` and Argo CD reports `<service>-development` as `Synced` and `Healthy`.

The repository and package can each be public or private. Argo CD reads private repositories through `argocd/argocd-github-org-repo-creds`; Kubernetes pulls private GHCR images through the replicated `ghcr-pull-secret`.
