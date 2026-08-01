# Repository setup

## GitHub repository

1. Create or provision `stonetusker/tusker-demo-notification-service` as either **Private** or **Public**.
2. Push this source to `main`.
3. In **Settings → Actions → General**, choose **Read and write permissions**.
4. Enable **Allow GitHub Actions to create and approve pull requests**.
5. Keep GitHub Actions enabled for the repository.

## Cluster prerequisite

The platform owner must run the following from the `tuskerblueprint` repository before onboarding the service:

```bash
scripts/backstage/configure-github-platform-secret.sh
```

That command creates the runtime credentials as Kubernetes Secrets. It requires a separate GHCR PAT classic with `read:packages` and uses restrictive temporary files that are deleted immediately after Secret creation:

```text
backstage/backstage-github-credentials
argocd/argocd-github-org-repo-creds
platform-secrets/ghcr-pull-credentials
```

Each application and Backstage declare an `ExternalSecret` that creates `ghcr-pull-secret` in its namespace. The service account already references that Secret, so both public and private GHCR packages use the same deployment manifest.

## Initial release

The `Service CI and Release` workflow validates source, runs tests and security scans, builds an immutable image, publishes it to GHCR and verifies the authenticated remote manifest.

1. Review the initial workflow.
2. Confirm the immutable image was published.
3. Review and merge the generated release PR. It must change only `deploy/overlays/development/kustomization.yaml`.
4. Merge the TuskerBlueprint onboarding PR.
5. Confirm Argo CD becomes `Synced` and `Healthy`.

The GHCR package may stay private. There is no mandatory package-visibility change.

## Local verification

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements-dev.txt
make validate
make lint
make test
make run
```

Open `http://localhost:8000/`.

## GitHub Free behavior

A pull request created with the repository `GITHUB_TOKEN` can display **Workflows awaiting approval**. Review the one-file release change, approve the workflows, wait for green checks and merge. This is an explicit deployment-approval step, not a failure.
