# Read an SYJ-RE-Workstation report

SYJ-RE-Workstation collects static evidence from an APK. A report is a set of observations and tool outputs, not a malware verdict, vulnerability confirmation or proof of safety.

## Start with the raw evidence files

- `REPORT-INFO.txt` records report context. Treat its input path as local metadata and do not publish it without reviewing it for personal information.
- `file.txt`, `size.txt` and `sha256.txt` identify the input file and record its digest.
- `badging.txt`, `permissions.txt` and `manifest-tree.txt` contain AAPT output.
- `archive-files.txt` and `dex-and-native-libraries.txt` list archive entries and matching DEX/native-library paths. The latter is an inventory only, not structural DEX or ELF analysis.
- `signature.txt` contains signature-verification output or a skipped status.
- `jadx-status.txt` records optional JADX execution status. `jadx.log` and the `jadx/` output directory are created when JADX is installed and invoked.

## Read SUMMARY.md

`SUMMARY.md` is generated from the raw evidence files in the same report directory. It presents selected observations in a compact table and links back to the raw files. It does not infer missing values: empty or absent fields appear as `not available`. The summary is an index to evidence, not an independent analysis or security verdict.

The following excerpt is copied from the real `example-report-debian-13` artifact produced by a completed Debian 13 job in the GitHub Actions compatibility workflow. It is actual output from the CI-built disposable fixture, not an invented example:

```markdown
| Field | Value |
|---|---|
| Package | org.syj.reworkstation.sample |
| Version code | not available |
| Version name | not available |
| Minimum SDK | 21 |
| Target SDK | 28 |
| SHA-256 | 24a7da00a55e6c14d95ef6c921a741e7ff8bf5e39dbf26228234761d2096f2e8 |
| Signature status | failed |
| JADX status | jadx not installed; decompilation skipped. |
```

The signature status is `failed` because this generated fixture is unsigned; it is not a malware finding. JADX was unavailable in that CI job, so decompilation was skipped.

## Read tool-versions.txt

`tool-versions.txt` records only tool names and sanitized version tokens. It does not include executable paths, usernames or home-directory paths. Missing tools or unavailable versions are recorded as `unavailable`.

This excerpt is also copied verbatim from the same real Debian 13 CI artifact:

```text
aapt=0.2-debian
apksigner=0.9
JADX=unavailable
Java=21.0.13
```

The recorded versions describe that particular CI job, not every supported installation or a minimum-version guarantee.

## Interpret missing and failed results carefully

A missing evidence file or an empty field means the corresponding observation was not collected; it is not a zero value and must not be guessed. A signature check marked skipped means verification did not run. A failed signature check is an observation from the signing tool, not by itself a malware determination. A skipped or failed JADX step does not erase other evidence.

## Keep raw evidence together

Preserve the raw evidence files when sharing a report so reviewers can verify the underlying observations. Remove local paths and other personal data before sharing. Never upload an APK or report containing proprietary or private information without authorization.

## Scope

The project is early-stage and performs static evidence collection only. [![Compatibility workflow](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml/badge.svg)](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml)

CI covers GitHub-hosted Debian/Ubuntu amd64 containers only. Termux and Debian PRoot on Android are not CI-tested. Reported working on one Android device (Debian 13 PRoot via Termux, maintainer-reported, single data point); no independent reports yet. APKTool integration, ELF/native inspection, DEX structural analysis, JSON/HTML report exports, YARA scanning and dynamic analysis are not implemented.
