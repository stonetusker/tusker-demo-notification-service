# Code review

## Scope

The review covers application behavior, browser assets, dependency pins, test coverage, container hardening, GitHub Actions, secret scanning, image scanning, SBOM generation, catalog metadata, TechDocs and all Kustomize overlays.

## Resolved findings

- The application source was moved out of the IDP platform repository.
- The notification store is bounded and protected by a lock.
- The UI and API remain in one hardened container to avoid an unnecessary frontend deployment.
- Current-source Gitleaks is used because unrelated historical platform findings belong to the platform remediation workflow.
- GitHub Advanced Security SARIF upload is not required, preserving GitHub Free compatibility.
- Public-only GHCR checks were removed. Authenticated manifest verification and Kubernetes `imagePullSecrets` now support both public and private packages.
- The ServiceAccount consistently references `ghcr-pull-secret`; the secret value remains outside Git.
- Release changes are isolated to the development overlay and use immutable commit tags.
- Generated caches and coverage artifacts are excluded and rejected by validation.

## Operational prerequisites

- The TuskerBlueprint platform owner configures the Backstage, Argo CD and GHCR credentials as Kubernetes Secrets.
- GitHub Actions repository permissions allow release pull requests.
- Argo CD onboarding is merged only after a pullable immutable image exists.
- The GHCR token identity has `read:packages` and access to private packages when private visibility is selected.

## Validation evidence

- Repository validator: passed on a clean source tree.
- Application tests: 9 passed.
- Branch-aware test coverage: 93.75%, above the 85% release gate.
- Python syntax, HTML parsing, SVG parsing, JavaScript syntax and shell syntax: passed.
- Internal Markdown links and CSS custom-property resolution: passed.
- Workflow YAML and application YAML files: parsed with duplicate-key protection.
- The same tests passed against a freshly rendered golden-path repository.
