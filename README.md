# StoneTusker Demo Notification Service

This repository is the application side of the StoneTusker TuskerBlueprint demonstration. It owns the FastAPI service, executive browser UI, tests, OpenAPI definition, TechDocs, CI/CD and Kubernetes overlays. The IDP platform and Argo CD application registration live in `stonetusker/tuskerblueprint`.

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
4. verifies that the immutable tag exists;
5. verifies anonymous pull access for the public demo path;
6. opens a release PR updating only `deploy/overlays/development/kustomization.yaml`.

For the first version of the GHCR package, a platform owner changes its visibility to **Public** once and reruns the workflow. The workflow logs out of GHCR and verifies anonymous manifest access before it creates a release PR. Future versions retain the package visibility. This prevents Argo CD from onboarding an image that would later fail with `ImagePullBackOff`.

After the release PR is approved and merged, Argo CD reads this repository directly and deploys the development overlay into `demo-service-development`.

## Runtime access

```bash
kubectl -n demo-service-development port-forward service/demo-service 8081:80
```

Open `http://localhost:8081/`.

## Repository boundary

- Application team: `group:default/developers`
- Application source, tests, docs and deployment overlays: this repository
- Platform, Backstage templates and Argo CD registration: `stonetusker/tuskerblueprint`
- Container image: `ghcr.io/stonetusker/tusker-demo-notification-service`

See `SETUP.md`, `docs/FIRST-RELEASE.md`, `docs/runbook.md` and `docs/CODE-REVIEW.md`.
