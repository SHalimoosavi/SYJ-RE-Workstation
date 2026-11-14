#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  echo "Usage: $0 /path/to/application.apk" >&2
  exit 2
}

[[ $# -eq 1 ]] || usage
APK=$1
[[ -f "$APK" ]] || { echo "ERROR: APK not found: $APK" >&2; exit 1; }

need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "ERROR: required tool not found: $1" >&2
    return 1
  }
}

need file
need sha256sum
need unzip
need aapt

if ! unzip -tqq "$APK" >/dev/null 2>&1; then
  echo "ERROR: input is not a readable ZIP/APK archive: $APK" >&2
  exit 1
fi
if ! unzip -Z1 "$APK" | grep -qx 'AndroidManifest.xml'; then
  echo "ERROR: archive does not contain AndroidManifest.xml: $APK" >&2
  exit 1
fi
if ! aapt dump badging "$APK" >/dev/null 2>&1; then
  echo "ERROR: AAPT could not read APK metadata: $APK" >&2
  exit 1
fi

NAME=$(basename "$APK" .apk)
BASE="${SYJ_RE_HOME:-$HOME/SYJ-RE-Workstation}"
OUT="$BASE/reports/$NAME"
mkdir -p "$OUT"

echo "[1/8] File type and size"
file "$APK" | tee "$OUT/file.txt"
stat -c 'size_bytes=%s' "$APK" > "$OUT/size.txt" 2>/dev/null || wc -c < "$APK" > "$OUT/size.txt"

echo "[2/8] SHA-256"
sha256sum "$APK" | tee "$OUT/sha256.txt"

echo "[3/8] Package metadata"
aapt dump badging "$APK" > "$OUT/badging.txt"

echo "[4/8] Permissions"
aapt dump permissions "$APK" > "$OUT/permissions.txt"

echo "[5/8] Decoded manifest tree"
aapt dump xmltree "$APK" AndroidManifest.xml > "$OUT/manifest-tree.txt"

echo "[6/8] Archive inventory"
unzip -Z1 "$APK" > "$OUT/archive-files.txt"
grep -E '(^|/)(classes([0-9]+)?\.dex|[^/]+\.so)$' "$OUT/archive-files.txt" \
  > "$OUT/dex-and-native-libraries.txt" || true

echo "[7/8] Signature verification"
if command -v apksigner >/dev/null 2>&1; then
  apksigner verify --verbose --print-certs "$APK" > "$OUT/signature.txt" 2>&1 || {
    echo "WARNING: signature verification reported an error; inspect signature.txt" >&2
  }
else
  echo "apksigner not installed; signature verification skipped." | tee "$OUT/signature.txt"
fi

echo "[8/8] Optional JADX decompilation"
if command -v jadx >/dev/null 2>&1; then
  mkdir -p "$OUT/jadx"
  set +e
  jadx --no-res -d "$OUT/jadx" "$APK" > "$OUT/jadx.log" 2>&1
  JADX_STATUS=$?
  set -e
  printf 'jadx_exit_code=%s\n' "$JADX_STATUS" > "$OUT/jadx-status.txt"
  if [[ $JADX_STATUS -ne 0 ]]; then
    echo "WARNING: JADX returned a non-zero exit code. Other reports are still valid; inspect jadx.log."
  fi
else
  echo "jadx not installed; decompilation skipped." | tee "$OUT/jadx-status.txt"
fi

cat > "$OUT/REPORT-INFO.txt" <<EOF
APK: $APK
Report directory: $OUT
Generated: $(date -Is 2>/dev/null || date)
Scope: static inspection only
EOF

echo
echo "Analysis complete: $OUT"
echo "Review the evidence; automated output is not a vulnerability verdict."
