#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  echo "Usage: $0 /path/to/report-directory" >&2
  exit 2
}

[[ $# -eq 1 ]] || usage
REPORT_DIR=$1
[[ -d "$REPORT_DIR" ]] || { echo "ERROR: report directory not found: $REPORT_DIR" >&2; exit 1; }

version_for() {
  local tool=$1 value=""
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf 'unavailable'
    return
  fi

  case "$tool" in
    bash)
      value=$(bash --version 2>&1 | awk 'NR == 1 { print $4; exit }')
      ;;
    file)
      value=$(file --version 2>&1 | awk 'NR == 1 { print $1; exit }')
      ;;
    sha256sum)
      value=$(sha256sum --version 2>&1 | awk 'NR == 1 { print $NF; exit }')
      ;;
    unzip)
      value=$(unzip -v 2>&1 | awk 'NR == 1 { print $2; exit }')
      ;;
    grep)
      value=$(grep --version 2>&1 | awk 'NR == 1 { print $NF; exit }')
      ;;
    aapt)
      value=$(aapt version 2>&1 | awk 'NR == 1 { for (i = 1; i <= NF; i++) if ($i ~ /^v?[0-9][[:alnum:].+_-]*[,]?$/) { gsub(/,/, "", $i); sub(/^v/, "", $i); print $i; exit } }')
      ;;
    apksigner)
      value=$(apksigner version 2>&1 | awk 'NF { print $NF; exit }')
      ;;
    jadx)
      value=$(jadx --version 2>&1 | awk 'NF { print $NF; exit }')
      ;;
  esac

  value=$(printf '%s' "$value" | tr -cd '[:alnum:]._+-')
  [[ -n "$value" ]] || value="unavailable"
  printf '%s' "$value"
}

{
  printf 'bash=%s\n' "$(version_for bash)"
  printf 'file=%s\n' "$(version_for file)"
  printf 'sha256sum=%s\n' "$(version_for sha256sum)"
  printf 'unzip=%s\n' "$(version_for unzip)"
  printf 'grep=%s\n' "$(version_for grep)"
  printf 'aapt=%s\n' "$(version_for aapt)"
  printf 'apksigner=%s\n' "$(version_for apksigner)"
  printf 'jadx=%s\n' "$(version_for jadx)"
} > "$REPORT_DIR/tool-versions.txt"
