#!/usr/bin/env bash
set -Eeuo pipefail

[[ $# -eq 2 ]] || {
  echo "Usage: $0 /path/to/report-A /path/to/report-B" >&2
  exit 2
}
A=$1
B=$2
[[ -d "$A" && -d "$B" ]] || { echo "Both report directories must exist." >&2; exit 1; }

for f in badging.txt permissions.txt dex-and-native-libraries.txt signature.txt; do
  echo
  echo "========== $f =========="
  if [[ -f "$A/$f" && -f "$B/$f" ]]; then
    diff -u "$A/$f" "$B/$f" || true
  else
    echo "Missing report in one or both directories."
  fi
done
