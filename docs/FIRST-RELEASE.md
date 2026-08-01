# First immutable release

Use this procedure immediately after Backstage creates the application repository.

1. Open **Actions → Service CI and Release** and inspect the initial run.
2. Confirm formatting, type checks, tests, coverage, current-source Gitleaks, Semgrep, Trivy and SBOM generation pass.
3. Confirm the workflow publishes `ghcr.io/<owner>/<repository>:<full-commit-sha>`.
4. GitHub normally creates a new container package as private. A platform owner opens **Organization → Packages → package → Package settings → Change visibility → Public**. This one-time step enables the anonymous pull path used by the public demo cluster.
5. Re-run the failed workflow. Its anonymous manifest check must pass before it can create a release pull request.
6. Review the release pull request. Only `deploy/overlays/development/kustomization.yaml` may change, and the new tag must be the full commit SHA.
7. GitHub may require a write user to approve workflows on a pull request created by `GITHUB_TOKEN`. Review the change and approve the workflows.
8. Merge the service release pull request.
9. Merge the separate TuskerBlueprint onboarding pull request that adds `gitops/generated-workloads/<service>/application.yaml`.
10. Wait for Argo CD to report `<service>-development` as `Synced` and `Healthy`.

The order is deliberate: the platform does not onboard Argo CD until a tested, immutable and anonymously pullable image exists.

For a private enterprise implementation, keep the package private and replace step 4 with a cluster-managed `imagePullSecret` delivered through External Secrets or another approved secret-management system.
