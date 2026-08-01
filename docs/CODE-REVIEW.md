# Code review

## Scope

The review covers application behavior, browser assets, dependency pins, test coverage, container hardening, GitHub Actions, secret scanning, image scanning, SBOM generation, catalog metadata, TechDocs and all Kustomize overlays.

## Resolved findings

- The application source was moved out of the IDP platform repository.
- The notification store is bounded and protected by a lock.
- The UI and API remain in one hardened container to avoid an unnecessary frontend deployment.
- Current-source Gitleaks is used because unrelated historical platform findings belong to the platform remediation workflow.
- GitHub Advanced Security SARIF upload is not required, preserving GitHub Free compatibility.
- The misleading GHCR visibility mutation was removed. CI now proves anonymous pull access before creating a deployable release.
- Release changes are isolated to the development overlay and use immutable commit tags.
- Generated caches and coverage artifacts are excluded and rejected by validation.

## Remaining operational prerequisites

- The first GHCR package version must be made public once for the zero-secret demo path.
- GitHub Actions repository permissions must allow release pull requests.
- Argo CD onboarding is merged only after a pullable immutable image exists.
- Production use should replace the public-package model with managed registry credentials and environment-specific promotion controls.
## Validation evidence

- Repository validator: passed on a clean source tree.
- Application tests: 9 passed.
- Branch-aware test coverage: 93.75%, above the 85% release gate.
- Python syntax, HTML parsing, SVG parsing, JavaScript syntax and shell syntax: passed.
- Internal Markdown links and CSS custom-property resolution: passed.
- Workflow YAML and all 16 application YAML files: parsed with duplicate-key protection.
- The same tests passed against a freshly rendered golden-path repository.

The packaging environment did not provide Docker, `kubectl`, Ruff or Mypy. The
repository workflows install the exact committed dependencies, run Ruff and Mypy,
build and scan the image, and render every Kustomize overlay before release.

