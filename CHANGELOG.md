# Changelog

All notable changes to SYJ-RE-Workstation are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow Semantic Versioning.

[![Compatibility workflow](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml/badge.svg)](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml)

## [0.1.0] - 2026-11-14

### Initial public release

The first public release contains the feature set present on `main` at publication:

- Bash-based APK static inspection and raw evidence files: `REPORT-INFO.txt`, `file.txt`, `size.txt`, `sha256.txt`, `badging.txt`, `permissions.txt`, `manifest-tree.txt`, `archive-files.txt`, `dex-and-native-libraries.txt`, `signature.txt` and `jadx-status.txt`.
- Evidence-only `SUMMARY.md`, generated from raw report files, with missing or empty fields marked `not available`.
- Sanitized `tool-versions.txt` containing tool names and version tokens rather than executable paths or personal paths.
- Report comparison helper for badging, permissions, DEX/native-library path inventory and signature output.
- Optional `apksigner` signature verification and optional JADX decompilation when those tools are installed.
- Termux and Debian bootstrap scripts.
- Analyzer regression tests, Bash syntax checks and ShellCheck.
- Four-image GitHub Actions compatibility matrix: Debian 12, Debian 13, Ubuntu 22.04 and Ubuntu 24.04, all in GitHub-hosted amd64 containers.
- Static project website, installation and usage pages, compatibility information, tutorials, security guidance, contributor documentation and roadmap.

### Not included

- APKTool integration (the analyzer does not invoke APKTool).
- ELF/native binary inspection.
- DEX structural analysis (the analyzer lists DEX paths only).
- JSON or HTML report exports.
- YARA scanning (YARA may be installed by the bootstrap, but the analyzer does not run scans).
- Dynamic analysis or APK execution.

### Validation and limitations

- The compatibility workflow is linked above. It validates GitHub-hosted Debian/Ubuntu amd64 containers only; it does not validate physical Android devices, native Termux or Debian PRoot on Android.
- Termux and Debian PRoot on Android remain unverified until reproducible community reports are submitted and reviewed.
- This is early-stage static evidence collection, not a malware verdict, vulnerability confirmation or proof that an APK is safe.
- Published: [v0.1.0 on 2026-11-14](https://github.com/SHalimoosavi/SYJ-RE-Workstation/releases/tag/v0.1.0).

[0.1.0]: https://github.com/SHalimoosavi/SYJ-RE-Workstation/releases/tag/v0.1.0
