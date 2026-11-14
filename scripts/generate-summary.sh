#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  echo "Usage: $0 /path/to/report-directory" >&2
  exit 2
}

[[ $# -eq 1 ]] || usage
REPORT_DIR=$1
[[ -d "$REPORT_DIR" ]] || { echo "ERROR: report directory not found: $REPORT_DIR" >&2; exit 1; }

badging_value() {
  local key=$1 value=""
  if [[ -f "$REPORT_DIR/badging.txt" ]]; then
    value=$(sed -n "1s/.*${key}='\\([^']*\\)'.*/\\1/p" "$REPORT_DIR/badging.txt" | head -n 1)
  fi
  if [[ -n "$value" ]]; then
    printf '%s' "$value"
  else
    printf 'not available'
  fi
}

line_value() {
  local file=$1 value=""
  if [[ -s "$file" ]]; then
    value=$(head -n 1 "$file")
  fi
  if [[ -n "$value" ]]; then
    printf '%s' "$value"
  else
    printf 'not available'
  fi
}

package_name=$(badging_value "name")
version_code=$(badging_value "versionCode")
version_name=$(badging_value "versionName")
min_sdk="not available"
target_sdk="not available"
if [[ -f "$REPORT_DIR/badging.txt" ]]; then
  min_sdk=$(sed -n "s/^sdkVersion:'\\([^']*\\)'.*/\\1/p" "$REPORT_DIR/badging.txt" | head -n 1)
  target_sdk=$(sed -n "s/^targetSdkVersion:'\\([^']*\\)'.*/\\1/p" "$REPORT_DIR/badging.txt" | head -n 1)
fi
[[ -n "$min_sdk" ]] || min_sdk="not available"
[[ -n "$target_sdk" ]] || target_sdk="not available"

apk_sha256="not available"
if [[ -s "$REPORT_DIR/sha256.txt" ]]; then
  apk_sha256=$(awk 'NR == 1 { print $1; exit }' "$REPORT_DIR/sha256.txt")
  [[ -n "$apk_sha256" ]] || apk_sha256="not available"
fi

signature_status="not available"
if [[ -s "$REPORT_DIR/signature.txt" ]]; then
  if grep -qi 'signature verification skipped' "$REPORT_DIR/signature.txt"; then
    signature_status="skipped"
  elif grep -qiE 'DOES NOT VERIFY|ERROR:' "$REPORT_DIR/signature.txt"; then
    signature_status="does not verify"
  elif grep -q '^Verifies$' "$REPORT_DIR/signature.txt"; then
    signature_status="verifies"
  fi
fi

jadx_status=$(line_value "$REPORT_DIR/jadx-status.txt")

cat > "$REPORT_DIR/SUMMARY.md" <<EOF
# APK Analysis Summary

Values below are extracted from this report directory's raw evidence files. Missing or empty values are shown as `not available`; no values are inferred.

| Field | Value |
|---|---|
| Package | $package_name |
| Version code | $version_code |
| Version name | $version_name |
| Minimum SDK | $min_sdk |
| Target SDK | $target_sdk |
| SHA-256 | $apk_sha256 |
| Signature status | $signature_status |
| JADX status | $jadx_status |

## Raw evidence

- Package metadata: [badging.txt](badging.txt)
- Permissions: [permissions.txt](permissions.txt)
- Manifest tree: [manifest-tree.txt](manifest-tree.txt)
- Archive inventory: [archive-files.txt](archive-files.txt)
- Signature output: [signature.txt](signature.txt)
- JADX status: [jadx-status.txt](jadx-status.txt)

This summary is a convenience index of collected static evidence. It is not a malware verdict and does not prove that an APK is safe.
EOF
