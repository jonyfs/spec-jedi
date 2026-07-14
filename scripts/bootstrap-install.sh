#!/usr/bin/env bash
# Spec Jedi standalone bootstrap installer (specs/024-bootstrap-installer,
# references/skill-roadmap.md "Sub-Project B"). A curl-friendly one-liner
# that installs Spec Jedi into a project WITHOUT cloning the repository
# first: fetches a published GitHub Release's downloadable tarball
# (scripts/package-release.sh's spec-jedi-<version>.tar.gz), extracts it,
# and runs the bundled scripts/install.sh.
#
#   curl -fsSL https://raw.githubusercontent.com/jonyfs/spec-jedi/main/scripts/bootstrap-install.sh \
#     | bash -s -- [TARGET_DIR] [--harness HARNESS] [--auto] [--version vX.Y.Z]
#
# Depends entirely on a real GitHub Release existing (Constitution
# Principle XI: cutting a release is always a deliberate, maintainer-
# driven step). This project's own first release has not been cut as of
# this script's authorship, so the "no release found" path below is not
# a hypothetical -- it's the actual current state, and fails with a
# clear, honest message rather than a cryptic curl/API error.
set -euo pipefail

repo="jonyfs/spec-jedi"
target_dir="."
version=""
install_args=()

usage() {
  cat <<'EOF'
Usage: bootstrap-install.sh [TARGET_DIR] [--harness HARNESS] [--auto] [--version vX.Y.Z]

Downloads a published Spec Jedi release from GitHub (no git clone
required) and runs its bundled scripts/install.sh against TARGET_DIR
(defaults to the current directory).

  --version    Install a specific tagged release instead of the latest
               one (e.g. --version v0.1.0).

--harness and --auto are forwarded to install.sh unchanged; see
./scripts/install.sh --help (from a checkout) for what they do.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --version)
      version="${2:-}"
      shift 2
      ;;
    --harness)
      install_args+=("--harness" "${2:-}")
      shift 2
      ;;
    --auto)
      install_args+=("--auto")
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      target_dir="$1"
      shift
      ;;
  esac
done

api_url="https://api.github.com/repos/$repo/releases/latest"
if [ -n "$version" ]; then
  api_url="https://api.github.com/repos/$repo/releases/tags/$version"
fi

echo "📡 Looking up Spec Jedi release (${version:-latest})..."
# curl -f suppresses the response body on any HTTP error (404, 403
# rate-limit, 5xx alike), so a transient failure and a genuine "no
# release" look identical here -- retry a few times before concluding
# it's the latter, rather than surfacing a misleading permanent-looking
# message for what might just be a rate limit or network blip. Capture
# the actual HTTP status separately so the failure message is honest
# about which of those it actually was.
# Anonymous GitHub API calls share a 60/hour-per-IP limit; GitHub-hosted
# CI runners (macOS in particular) pool a small set of egress IPs across
# a large volume of unrelated global traffic and can exhaust that quota
# without this script alone making many calls. If GITHUB_TOKEN happens
# to be set (e.g. this script invoked from within a GitHub Actions job),
# use it to raise the effective limit to 5000/hour -- end users running
# this outside CI simply won't have the variable set and stay anonymous.
auth_header=()
if [ -n "${GITHUB_TOKEN:-}" ]; then
  auth_header=(-H "Authorization: Bearer $GITHUB_TOKEN")
fi

response=""
http_status=""
for attempt in 1 2 3; do
  http_status="$(curl -sSL "${auth_header[@]}" -o /tmp/spec-jedi-bootstrap-response.$$ -w '%{http_code}' "$api_url" 2>/dev/null || true)"
  if [ "$http_status" = "200" ]; then
    response="$(cat /tmp/spec-jedi-bootstrap-response.$$ 2>/dev/null || true)"
    rm -f /tmp/spec-jedi-bootstrap-response.$$
    break
  fi
  rm -f /tmp/spec-jedi-bootstrap-response.$$
  if [ "$attempt" -lt 3 ]; then
    sleep "$attempt"
  fi
done

if [ -z "$response" ] || printf '%s' "$response" | grep -q '"message": *"Not Found"'; then
  echo
  echo "🔭 No published Spec Jedi release found${version:+ for $version}${http_status:+ (last HTTP status: $http_status)}."
  echo "This project cuts releases deliberately (Constitution Principle XI) --"
  echo "none may exist yet, the requested version may not exist, or the"
  echo "network request itself may have failed."
  echo
  echo "Alternatives:"
  echo "  - List available releases: https://github.com/$repo/releases"
  echo "  - Clone the repo directly and run scripts/install.sh from a checkout:"
  echo "      git clone https://github.com/$repo.git && cd spec-jedi && ./scripts/install.sh"
  exit 1
fi

# Minimal JSON field extraction (grep/sed only, no jq dependency) --
# keeps this a true zero-dependency one-liner, consistent with the
# Homebrew/SDKMAN-style bootstrap this script is modeled on.
tag_name="$(printf '%s' "$response" | grep -m1 '"tag_name"' | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')"
asset_url="$(printf '%s' "$response" | grep -o '"browser_download_url": *"[^"]*spec-jedi-[^"]*\.tar\.gz"' | head -1 | sed -E 's/.*"(https:[^"]+)"$/\1/')"

if [ -z "$asset_url" ]; then
  echo "FAIL: release '$tag_name' has no spec-jedi-*.tar.gz asset — is this a valid Spec Jedi release?"
  exit 1
fi

echo "📦 Found $tag_name — downloading $(basename "$asset_url")..."
work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

curl -fsSL "$asset_url" -o "$work_dir/spec-jedi.tar.gz"
tar -xzf "$work_dir/spec-jedi.tar.gz" -C "$work_dir"

extracted_dir="$(find "$work_dir" -maxdepth 1 -type d -name 'spec-jedi-*' | head -1)"
if [ -z "$extracted_dir" ] || [ ! -f "$extracted_dir/scripts/install.sh" ]; then
  echo "FAIL: downloaded archive doesn't contain scripts/install.sh — unexpected release layout"
  exit 1
fi

echo "🚀 Running install.sh from $tag_name..."
echo
chmod +x "$extracted_dir/scripts/install.sh"
"$extracted_dir/scripts/install.sh" "$target_dir" "${install_args[@]}"
