#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  printf 'Usage: %s /path/to/report-directory\n' "$0" >&2
  exit 2
}

[[ $# -eq 1 ]] || usage
REPORT_DIR=$1
[[ -d "$REPORT_DIR" ]] || { printf 'ERROR: report directory not found: %s\n' "$REPORT_DIR" >&2; exit 1; }

badging_value() {
  local key=$1 value=''
  local file="$REPORT_DIR/badging.txt"
  if [[ -f "$file" ]]; then
    value=$(sed -n "1s/.*[[:space:]]${key}='\\([^']*\\)'.*/\\1/p" "$file" | head -n 1)
  fi
  [[ -n "$value" ]] || value='not available'
  printf '%s' "$value"
}

first_line() {
  local file=$1 value=''
  if [[ -s "$file" ]]; then
    value=$(head -n 1 "$file")
  fi
  [[ -n "$value" ]] || value='not available'
  printf '%s' "$value"
}

markdown_cell() {
  local value=$1
  value=${value//$'\n'/ }
  value=${value//|/\\|}
  printf '%s' "$value"
}

package_name=$(badging_value name)
version_code=$(badging_value versionCode)
version_name=$(badging_value versionName)
min_sdk='not available'
target_sdk='not available'
if [[ -f "$REPORT_DIR/badging.txt" ]]; then
  min_sdk=$(sed -n "s/^sdkVersion:'\\([^']*\\)'.*/\\1/p" "$REPORT_DIR/badging.txt" | head -n 1)
  target_sdk=$(sed -n "s/^targetSdkVersion:'\\([^']*\\)'.*/\\1/p" "$REPORT_DIR/badging.txt" | head -n 1)
fi
[[ -n "$min_sdk" ]] || min_sdk='not available'
[[ -n "$target_sdk" ]] || target_sdk='not available'

apk_sha256='not available'
if [[ -s "$REPORT_DIR/sha256.txt" ]]; then
  apk_sha256=$(awk 'NR == 1 { print $1; exit }' "$REPORT_DIR/sha256.txt")
  [[ -n "$apk_sha256" ]] || apk_sha256='not available'
fi

signature_status='not available'
if [[ -s "$REPORT_DIR/signature.txt" ]]; then
  if grep -qiE 'verification skipped|not installed.*skipped' "$REPORT_DIR/signature.txt"; then
    signature_status='skipped'
  elif grep -qiE 'DOES NOT VERIFY|ERROR:|failed|verification failed' "$REPORT_DIR/signature.txt"; then
    signature_status='failed'
  elif grep -q '^Verifies$' "$REPORT_DIR/signature.txt"; then
    signature_status='verified'
  fi
fi

jadx_status=$(first_line "$REPORT_DIR/jadx-status.txt")

{
  printf '# APK Analysis Summary\n\n'
  printf 'Values below are extracted only from raw evidence files in this report directory. Missing or empty fields are shown as not available; no values are inferred.\n\n'
  printf '| Field | Value |\n|---|---|\n'
  printf '| Package | %s |\n' "$(markdown_cell "$package_name")"
  printf '| Version code | %s |\n' "$(markdown_cell "$version_code")"
  printf '| Version name | %s |\n' "$(markdown_cell "$version_name")"
  printf '| Minimum SDK | %s |\n' "$(markdown_cell "$min_sdk")"
  printf '| Target SDK | %s |\n' "$(markdown_cell "$target_sdk")"
  printf '| SHA-256 | %s |\n' "$(markdown_cell "$apk_sha256")"
  printf '| Signature status | %s |\n' "$(markdown_cell "$signature_status")"
  printf '| JADX status | %s |\n\n' "$(markdown_cell "$jadx_status")"
  printf '## Raw evidence files\n\n'
  for evidence in REPORT-INFO.txt file.txt size.txt sha256.txt badging.txt permissions.txt manifest-tree.txt archive-files.txt dex-and-native-libraries.txt signature.txt jadx-status.txt jadx.log; do
    if [[ -f "$REPORT_DIR/$evidence" ]]; then
      printf -- '- [%s](%s)\n' "$evidence" "$evidence"
    else
      printf -- '- %s: not available\n' "$evidence"
    fi
  done
  printf '\nThis summary indexes collected static evidence. It is not a malware verdict and does not prove that an APK is safe.\n'
} > "$REPORT_DIR/SUMMARY.md"
