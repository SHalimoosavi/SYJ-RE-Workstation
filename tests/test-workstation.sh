#!/usr/bin/env bash
set -Eeuo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ANALYZER="$ROOT/scripts/analyze-apk.sh"
COMPARE="$ROOT/scripts/compare-reports.sh"
SUMMARY="$ROOT/scripts/generate-summary.sh"
VERSIONS="$ROOT/scripts/write-tool-versions.sh"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
pass() { printf 'PASS: %s\n' "$*"; }

if "$ANALYZER" >"$TMP/no-args.out" 2>&1; then fail 'no-argument invocation unexpectedly succeeded'; fi
grep -q '^Usage:' "$TMP/no-args.out" || fail 'no-argument usage message missing'
pass 'analyzer rejects no arguments'

if "$ANALYZER" one.apk two.apk >"$TMP/too-many.out" 2>&1; then fail 'too-many-arguments invocation unexpectedly succeeded'; fi
grep -q '^Usage:' "$TMP/too-many.out" || fail 'too-many-arguments usage message missing'
pass 'analyzer rejects too many arguments'

if "$ANALYZER" "$TMP/missing.apk" >"$TMP/missing.out" 2>&1; then fail 'missing input unexpectedly succeeded'; fi
grep -q 'APK not found' "$TMP/missing.out" || fail 'missing-file diagnostic absent'
pass 'analyzer rejects missing files'

printf 'not an APK\n' > "$TMP/not-an-apk.apk"
if "$ANALYZER" "$TMP/not-an-apk.apk" >"$TMP/non-apk.out" 2>&1; then fail 'non-APK input unexpectedly succeeded'; fi
grep -q 'not a readable ZIP/APK archive' "$TMP/non-apk.out" || fail 'non-APK diagnostic absent'
pass 'analyzer rejects non-APK input'

mkdir -p "$TMP/minimal-bin"
for command_name in bash file sha256sum unzip grep basename mkdir tee stat wc date; do
  command -v "$command_name" >/dev/null || fail "test host lacks $command_name"
  ln -s "$(command -v "$command_name")" "$TMP/minimal-bin/$command_name"
done
if PATH="$TMP/minimal-bin" HOME="$TMP" "$ANALYZER" "$TMP/not-an-apk.apk" >"$TMP/missing-dep.out" 2>&1; then
  fail 'missing-dependency invocation unexpectedly succeeded'
fi
grep -q 'required tool not found: aapt' "$TMP/missing-dep.out" || fail 'missing dependency diagnostic absent'
pass 'analyzer reports missing required dependency'

mkdir -p "$TMP/no-tools-report"
PATH='' /bin/bash "$VERSIONS" "$TMP/no-tools-report"
for tool in aapt apksigner JADX Java; do
  grep -Fxq "$tool=unavailable" "$TMP/no-tools-report/tool-versions.txt" || fail "missing tool was not marked unavailable: $tool"
done
pass 'tool versions mark missing optional tools unavailable'

[[ -n "${SYJ_TEST_APK:-}" && -f "$SYJ_TEST_APK" ]] || fail 'SYJ_TEST_APK must point to the CI-built APK'
export SYJ_RE_HOME="$TMP/workstation"
"$ANALYZER" "$SYJ_TEST_APK" >"$TMP/analyze.out"
REPORT="$SYJ_RE_HOME/reports/$(basename "$SYJ_TEST_APK" .apk)"
for output in REPORT-INFO.txt file.txt size.txt sha256.txt badging.txt permissions.txt manifest-tree.txt archive-files.txt dex-and-native-libraries.txt signature.txt jadx-status.txt SUMMARY.md tool-versions.txt; do
  [[ -f "$REPORT/$output" ]] || fail "expected report output missing: $output"
done
for output in REPORT-INFO.txt file.txt size.txt sha256.txt badging.txt permissions.txt manifest-tree.txt archive-files.txt signature.txt jadx-status.txt SUMMARY.md tool-versions.txt; do
  [[ -s "$REPORT/$output" ]] || fail "expected report output is empty: $output"
done
grep -Fq 'Raw evidence files' "$REPORT/SUMMARY.md" || fail 'summary raw evidence section missing'
grep -Fq '[badging.txt](badging.txt)' "$REPORT/SUMMARY.md" || fail 'summary does not link raw badging evidence'
if grep -Eq '(/home/|/root/|/data/data/|/storage/emulated/)' "$REPORT/tool-versions.txt"; then
  fail 'tool-versions.txt contains a personal or home path'
fi
awk -F= 'NF != 2 || $1 !~ /^(aapt|apksigner|JADX|Java)$/ || ($2 != "unavailable" && $2 !~ /^[0-9][A-Za-z0-9.+_-]*$/) { exit 1 }' "$REPORT/tool-versions.txt" || fail 'tool-versions.txt contains fields other than tool names and version tokens'
pass 'analyzer creates raw-evidence summary and sanitized tool versions'

for sample_name in 'fixture with spaces.apk' 'fixture-مرحبا-应用.apk'; do
  sample_path="$TMP/$sample_name"
  cp "$SYJ_TEST_APK" "$sample_path"
  "$ANALYZER" "$sample_path" > "$TMP/path-test.out"
  report_name=${sample_name%.apk}
  path_report="$SYJ_RE_HOME/reports/$report_name"
  [[ -s "$path_report/SUMMARY.md" ]] || fail "summary missing for APK path: $sample_name"
  [[ -s "$path_report/tool-versions.txt" ]] || fail "tool versions missing for APK path: $sample_name"
  grep -Fq 'org.syj.reworkstation.sample' "$path_report/SUMMARY.md" || fail "package missing from summary for APK path: $sample_name"
done
pass 'summary and tool versions handle spaces and non-ASCII APK paths'

mkdir -p "$TMP/incomplete-report"
printf "package: name='org.example.empty' versionCode='' versionName=''\n" > "$TMP/incomplete-report/badging.txt"
bash "$SUMMARY" "$TMP/incomplete-report"
grep -Fq '| Package | org.example.empty |' "$TMP/incomplete-report/SUMMARY.md" || fail 'summary did not extract package from raw badging'
for field in 'Version code' 'Version name' 'Minimum SDK' 'Target SDK' 'SHA-256' 'Signature status' 'JADX status'; do
  grep -Fq "| $field | not available |" "$TMP/incomplete-report/SUMMARY.md" || fail "missing raw field was not marked not available: $field"
done
pass 'summary uses not available for empty or missing raw fields'

mkdir -p "$TMP/signature-skipped" "$TMP/signature-failed" "$TMP/signature-verified"
printf 'apksigner not installed; signature verification skipped.\n' > "$TMP/signature-skipped/signature.txt"
printf 'DOES NOT VERIFY\nERROR: signature verification failed\n' > "$TMP/signature-failed/signature.txt"
printf 'Verifies\n' > "$TMP/signature-verified/signature.txt"
bash "$SUMMARY" "$TMP/signature-skipped"
bash "$SUMMARY" "$TMP/signature-failed"
bash "$SUMMARY" "$TMP/signature-verified"
grep -Fq '| Signature status | skipped |' "$TMP/signature-skipped/SUMMARY.md" || fail 'skipped signature was not recorded'
grep -Fq '| Signature status | failed |' "$TMP/signature-failed/SUMMARY.md" || fail 'failed signature was not recorded'
grep -Fq '| Signature status | verified |' "$TMP/signature-verified/SUMMARY.md" || fail 'verified signature was not recorded'
pass 'summary distinguishes skipped, failed and verified signatures'

mkdir -p "$TMP/report-a" "$TMP/report-b"
for f in badging.txt permissions.txt dex-and-native-libraries.txt signature.txt; do
  printf 'same\n' > "$TMP/report-a/$f"
  printf 'same\n' > "$TMP/report-b/$f"
done
"$COMPARE" "$TMP/report-a" "$TMP/report-b" >"$TMP/compare-same.out"
pass 'report comparison handles identical reports'

printf 'different\n' > "$TMP/report-b/permissions.txt"
set +e
"$COMPARE" "$TMP/report-a" "$TMP/report-b" >"$TMP/compare-different.out"
compare_status=$?
set -e
[[ $compare_status -eq 0 ]] || fail "documented diff exit-status quirk changed: got $compare_status"
grep -q '^-same' "$TMP/compare-different.out" || grep -q '^+different' "$TMP/compare-different.out" || fail 'comparison diff output missing'
pass 'report comparison displays differences but exits zero (documented quirk)'

if "$COMPARE" "$TMP/report-a" "$TMP/absent" >"$TMP/compare-missing.out" 2>&1; then fail 'comparison with missing directory unexpectedly succeeded'; fi
pass 'report comparison rejects missing report directory'
