#!/usr/bin/env bash
# Star every extra listed in catalog/extras.txt.
# Requires GitHub CLI with a token that can star public repos:
#   gh auth login
#   # or: GH_TOKEN with scope public_repo (classic) / fine-grained "Starring"
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
list="$root/catalog/extras.txt"
if [[ ! -f "$list" ]]; then
  echo "missing $list" >&2
  exit 1
fi
if ! command -v gh >/dev/null 2>&1; then
  echo "gh is required: https://cli.github.com/" >&2
  exit 1
fi
ok=0
fail=0
while IFS= read -r slug; do
  [[ -z "$slug" || "$slug" == \#* ]] && continue
  if gh api -X PUT "user/starred/${slug}" >/dev/null 2>&1; then
    echo "starred ${slug}"
    ok=$((ok + 1))
  else
    echo "FAILED  ${slug}" >&2
    fail=$((fail + 1))
  fi
done < "$list"
echo "done: ${ok} starred, ${fail} failed"
