#!/usr/bin/env bash
set -Eeuo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ANALYZER="$ROOT/scripts/analyze-apk.sh"
COMPARE="$ROOT/scripts/compare-reports.sh"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "PASS: $*"; }

if "$ANALYZER" >"$TMP/no-args.out" 2>&1; then fail "no-argument invocation unexpectedly succeeded"; fi
grep -q '^Usage:' "$TMP/no-args.out" || fail "no-argument usage message missing"
pass "analyzer rejects no arguments"

if "$ANALYZER" one.apk two.apk >"$TMP/too-many.out" 2>&1; then fail "too-many-arguments invocation unexpectedly succeeded"; fi
grep -q '^Usage:' "$TMP/too-many.out" || fail "too-many-arguments usage message missing"
pass "analyzer rejects too many arguments"

if "$ANALYZER" "$TMP/missing.apk" >"$TMP/missing.out" 2>&1; then fail "missing input unexpectedly succeeded"; fi
grep -q 'APK not found' "$TMP/missing.out" || fail "missing-file diagnostic absent"
pass "analyzer rejects missing files"

printf 'not an APK\n' > "$TMP/not-an-apk.apk"
if "$ANALYZER" "$TMP/not-an-apk.apk" >"$TMP/non-apk.out" 2>&1; then fail "non-APK input unexpectedly succeeded"; fi
grep -q 'not a readable ZIP/APK archive' "$TMP/non-apk.out" || fail "non-APK diagnostic absent"
pass "analyzer rejects non-APK input"

mkdir -p "$TMP/minimal-bin"
for command_name in bash file sha256sum unzip grep basename mkdir tee stat wc date; do
  command -v "$command_name" >/dev/null || fail "test host lacks $command_name"
  ln -s "$(command -v "$command_name")" "$TMP/minimal-bin/$command_name"
done
if PATH="$TMP/minimal-bin" HOME="$TMP" "$ANALYZER" "$TMP/not-an-apk.apk" >"$TMP/missing-dep.out" 2>&1; then
  fail "missing-dependency invocation unexpectedly succeeded"
fi
grep -q 'required tool not found: aapt' "$TMP/missing-dep.out" || fail "missing dependency diagnostic absent"
pass "analyzer reports missing required dependency"

[[ -n "${SYJ_TEST_APK:-}" && -f "$SYJ_TEST_APK" ]] || fail "SYJ_TEST_APK must point to the CI-built APK"
export SYJ_RE_HOME="$TMP/workstation"
"$ANALYZER" "$SYJ_TEST_APK" >"$TMP/analyze.out"
REPORT="$SYJ_RE_HOME/reports/$(basename "$SYJ_TEST_APK" .apk)"
for output in REPORT-INFO.txt file.txt size.txt sha256.txt badging.txt permissions.txt manifest-tree.txt archive-files.txt dex-and-native-libraries.txt signature.txt jadx-status.txt; do
  [[ -f "$REPORT/$output" ]] || fail "expected report output missing: $output"
done
for output in REPORT-INFO.txt file.txt size.txt sha256.txt badging.txt permissions.txt manifest-tree.txt archive-files.txt signature.txt jadx-status.txt; do
  [[ -s "$REPORT/$output" ]] || fail "expected report output is empty: $output"
done
if [[ -n "${SYJ_TEST_REPORT_DIR:-}" ]]; then\n  mkdir -p "$SYJ_TEST_REPORT_DIR"\n  cp -a "$REPORT" "$SYJ_TEST_REPORT_DIR/"\nfi\npass "analyzer creates expected evidence files"

mkdir -p "$TMP/report-a" "$TMP/report-b"
for f in badging.txt permissions.txt dex-and-native-libraries.txt signature.txt; do
  printf 'same\n' > "$TMP/report-a/$f"
  printf 'same\n' > "$TMP/report-b/$f"
done
"$COMPARE" "$TMP/report-a" "$TMP/report-b" >"$TMP/compare-same.out"
pass "report comparison handles identical reports"

printf 'different\n' > "$TMP/report-b/permissions.txt"
set +e
"$COMPARE" "$TMP/report-a" "$TMP/report-b" >"$TMP/compare-different.out"
compare_status=$?
set -e
[[ $compare_status -eq 0 ]] || fail "documented diff exit-status quirk changed: got $compare_status"
grep -q '^-same' "$TMP/compare-different.out" || grep -q '^+different' "$TMP/compare-different.out" || fail "comparison diff output missing"
pass "report comparison displays differences but exits zero (documented quirk)"

if "$COMPARE" "$TMP/report-a" "$TMP/absent" >"$TMP/compare-missing.out" 2>&1; then fail "comparison with missing directory unexpectedly succeeded"; fi
pass "report comparison rejects missing report directory"
