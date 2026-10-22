#!/usr/bin/env bash
# Prepares your machine for the cooking lessons.
#
#  - checks that OpenTofu (tofu) is installed (>= 1.10 recommended,
#    needed for ephemeral resources in later lessons)
#  - builds the oven provider from the sibling terraform-provider-oven
#    repository
#  - installs it as ~/bin/terraform-provider-oven
#  - registers an OpenTofu dev_override in ~/.tofurc pointing at ~/bin,
#    so every tofu command in these lessons uses your locally built
#    provider without publishing anything to a registry
#
# Usage: ./setup.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROVIDER_DIR="$SCRIPT_DIR/../terraform-provider-oven"
BIN_DIR="${HOME}/bin"
BIN_PATH="${BIN_DIR}/terraform-provider-oven"
TOFURC="${HOME}/.tofurc"
PROVIDER_ADDRESS="registry.opentofu.org/tom-tw/oven"

if ! command -v tofu >/dev/null 2>&1; then
  echo "error: 'tofu' not found. Install OpenTofu first: https://opentofu.org/docs/intro/install/" >&2
  exit 1
fi
TOFU_VERSION="$(tofu version | head -1 | awk '{print $2}' | tr -d v)"
echo "-> OpenTofu v${TOFU_VERSION} found"

if ! command -v go >/dev/null 2>&1; then
  echo "error: 'go' not found. Install Go first: https://go.dev/dl/" >&2
  exit 1
fi

if [ ! -d "$PROVIDER_DIR" ]; then
  echo "error: provider repository not found at ${PROVIDER_DIR}" >&2
  exit 1
fi

echo "-> building the oven provider"
mkdir -p "$BIN_DIR"
(cd "$PROVIDER_DIR" && go build -o "$BIN_PATH" .)
echo "-> installed ${BIN_PATH}"

if [ -f "$TOFURC" ] && grep -q "$PROVIDER_ADDRESS" "$TOFURC"; then
  echo "-> ~/.tofurc already has the ${PROVIDER_ADDRESS} dev override"
else
  if [ ! -f "$TOFURC" ]; then
    printf 'provider_installation {\n  dev_overrides {\n    "%s" = "%s"\n  }\n}\n' \
      "$PROVIDER_ADDRESS" "$BIN_DIR" > "$TOFURC"
    echo "-> created $TOFURC with the dev override"
  else
    cat >> "$TOFURC" <<EOF

provider_installation {
  dev_overrides {
    "${PROVIDER_ADDRESS}" = "${BIN_DIR}"
  }
}
EOF
    echo "-> appended the dev override to the existing $TOFURC"
  fi
fi

echo
echo "The kitchen is ready. Start with lesson 01:"
echo "  cd $(basename "$SCRIPT_DIR")/01-hello-kitchen"
echo "  tofu plan"
echo
echo "No 'tofu init' needed: dev_overrides load the local provider at"
echo "plan/apply time, and OpenTofu >= 1.13 refuses init-with-overrides"
echo "by design. Re-run ./setup.sh after changing the provider code to"
echo "rebuild it."