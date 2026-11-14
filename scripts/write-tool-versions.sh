#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  printf 'Usage: %s /path/to/report-directory\n' "$0" >&2
  exit 2
}

[[ $# -eq 1 ]] || usage
REPORT_DIR=$1
[[ -d "$REPORT_DIR" ]] || { printf 'ERROR: report directory not found: %s\n' "$REPORT_DIR" >&2; exit 1; }

version_for() {
  local tool=$1 raw='' value='' token=''
  local -a tokens=()
  if ! command -v "$tool" >/dev/null 2>&1; then
    printf 'unavailable'
    return
  fi

  case "$tool" in
    aapt) raw=$(aapt version 2>&1) || raw='' ;;
    apksigner) raw=$(apksigner version 2>&1) || raw='' ;;
    jadx) raw=$(jadx --version 2>&1) || raw='' ;;
    java)
      raw=$(java -version 2>&1) || raw=''
      if [[ "$raw" =~ \"([0-9][A-Za-z0-9.+_-]*)\" ]]; then
        value=${BASH_REMATCH[1]}
      fi
      ;;
  esac

  if [[ "$tool" != java ]]; then
    read -r -a tokens <<< "$raw"
    for token in "${tokens[@]}"; do
      token=${token#,}
      token=${token#v}
      if [[ "$token" =~ ^[0-9][A-Za-z0-9.+_-]*$ ]]; then
        value=$token
      fi
    done
  fi

  [[ "$value" =~ ^[0-9][A-Za-z0-9.+_-]*$ ]] || value='unavailable'
  printf '%s' "$value"
}

{
  printf 'aapt=%s\n' "$(version_for aapt)"
  printf 'apksigner=%s\n' "$(version_for apksigner)"
  printf 'JADX=%s\n' "$(version_for jadx)"
  printf 'Java=%s\n' "$(version_for java)"
} > "$REPORT_DIR/tool-versions.txt"
