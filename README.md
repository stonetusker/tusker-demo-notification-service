# Stonetusker Demo Notification Service

This repository is the application side of the Stonetusker TuskerBlueprint demonstration. It owns the FastAPI service, executive browser UI, tests, OpenAPI definition, TechDocs, CI/CD and Kubernetes overlays. The IDP platform and Argo CD application registration live in `stonetusker/tuskerblueprint`.

## Local developer workflow

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

## Delivery workflow

Pull requests run formatting, linting, type checks, unit tests, current-source Gitleaks, Semgrep and Trivy. A merge to `main`:

1. builds an immutable image;
2. scans the image and generates an SPDX SBOM;
3. publishes immutable and `main` GHCR tags;
4. verifies the immutable tag through the authenticated GitHub Actions session;
5. opens a release PR updating only `deploy/overlays/development/kustomization.yaml`.

The package may remain private or be made public. Kubernetes always uses the `ghcr-pull-secret` attached to the service account. TuskerBlueprint stores the source GHCR credential in Kubernetes and External Secrets Operator materializes it through an explicit per-namespace `ExternalSecret`. No registry credential is committed to this repository.

After the release PR is approved and merged, Argo CD reads this repository directly and deploys the development overlay into `demo-service-development`. Argo CD organization-level repository credentials allow this repository itself to be public or private.

## Runtime access

```bash
kubectl -n demo-service-development port-forward service/demo-service 8081:80
```

Open `http://localhost:8081/`.

## Repository boundary

- Application team: `group:default/developers`
- Application source, tests, docs and deployment overlays: this repository
- Platform, Backstage templates and Argo CD/GHCR credentials: `stonetusker/tuskerblueprint`
- Container image: `ghcr.io/stonetusker/tusker-demo-notification-service`

See `SETUP.md`, `docs/FIRST-RELEASE.md`, `docs/runbook.md` and `docs/CODE-REVIEW.md`.
