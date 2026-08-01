# Repository setup

## GitHub repository

1. Create or provision the public repository `stonetusker/tusker-demo-notification-service`.
2. Push this source to `main`.
3. In **Settings → Actions → General**, choose **Read and write permissions**.
4. Enable **Allow GitHub Actions to create and approve pull requests**.
5. Keep GitHub Actions enabled for the repository.

## Initial release

The `Service CI and Release` workflow validates source, runs tests and security scans, builds an immutable image, publishes it to GHCR and verifies the remote manifest.

GitHub creates a new GHCR package as private. The first workflow therefore stops at the anonymous-pull gate. Complete this one-time approval:

1. Open **StoneTusker organization → Packages**.
2. Open the generated container package.
3. Select **Package settings → Change visibility → Public**.
4. Re-run the failed workflow.
5. Review and merge the generated release PR. It must change only `deploy/overlays/development/kustomization.yaml`.

Future releases of the same package do not need the visibility step.

## Platform onboarding

The Argo CD `Application` is maintained in `stonetusker/tuskerblueprint`. Merge the platform onboarding PR only after the immutable release PR exists and the image is anonymously pullable.

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
