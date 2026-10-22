#!/usr/bin/env bash
# Instructor grading scoreboard for the overcooked lessons.
#
# Usage:
#   ./grade.sh          # grade all lessons, print scoreboard
#   ./grade.sh 05       # grade one lesson
#
# Each lesson passes when its own `tofu test` suite is green. The exit
# code is 1 while any graded lesson still fails — handy for pipelines.
#
# Note: lesson 07 needs its local module installed; the script runs a
# one-time (noisy, expected-to-fail) `tofu init` only there before testing.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

FILTER="${1:-}"
TOTAL=0
GOLDEN=0

for lesson in [0-9][0-9]-*/; do
  num="${lesson%%-*}"
  name="${lesson#*-}"
  name="${name%/}"

  if [ -n "$FILTER" ] && [ "$FILTER" != "$num" ] && [ "$FILTER" != "${num#0}" ]; then
    continue
  fi

  TOTAL=$((TOTAL + 1))

  # Module-bearing lessons: install local modules first. The resolver
  # error is the documented dev-override behavior; the module installs
  # anyway. Harmless to skip elsewhere.
  if [ -d "${lesson}modules" ]; then
    (cd "$lesson" && tofu init >/dev/null 2>&1)
  fi

  if (cd "$lesson" && OVEN_STATE_DIR="$(mktemp -d)" tofu test >/dev/null 2>&1); then
    printf '\033[32m[✓ golden]\033[0m          %s\n' "$name"
    GOLDEN=$((GOLDEN + 1))
  else
    printf '\033[31m[✗ still overcooked]\033[0m %s\n' "$name"
  fi
  rm -rf "${lesson:?}/.terraform" "${lesson:?}/.terraform.lock.hcl"
done

echo
if [ "$GOLDEN" -eq "$TOTAL" ]; then
  echo "All $TOTAL lessons are golden. The kitchen is ready to serve."
else
  echo "Progress: $GOLDEN/$TOTAL lessons golden."
fi
[ "$GOLDEN" -eq "$TOTAL" ]