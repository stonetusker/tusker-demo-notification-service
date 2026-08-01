#!/usr/bin/env bash
set -euo pipefail

: "${IMAGE_NAME:?IMAGE_NAME is required}"

release="${1:-${GITHUB_SHA:-}}"
if [[ ! "${release}" =~ ^[0-9a-f]{40}$ ]]; then
  echo "usage: verify-public-package.sh <40-character-git-sha>" >&2
  exit 2
fi

image_ref="${IMAGE_NAME}:${release}"

# A previous login would make a private package look pullable. Remove the
# credential before testing the same anonymous path used by a zero-secret
# Argo CD workload.
docker logout ghcr.io >/dev/null 2>&1 || true

for attempt in 1 2 3 4 5 6; do
  if docker manifest inspect "${image_ref}" >/dev/null 2>&1; then
    echo "Anonymous GHCR pull verified: ${image_ref}"
    exit 0
  fi
  echo "Anonymous manifest lookup is not ready (${attempt}/6)."
  sleep 10
done

cat >&2 <<EOF
The image was published, but it is not anonymously pullable:
  ${image_ref}

For the public demo path, make the GHCR package public once:
  GitHub organization -> Packages -> package -> Package settings
  -> Change visibility -> Public

Then re-run this workflow. Future versions of the same package retain the
package visibility and pass this gate automatically.

For private enterprise delivery, replace this public-package gate with a
cluster-managed GHCR pull credential or external-secret integration.
EOF
exit 1
