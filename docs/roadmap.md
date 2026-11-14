# Project roadmap

This project is an early-stage Bash-based static APK inspection workstation. The phases below describe delivery status and future work; planned work is not implemented functionality.

[![Compatibility workflow](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml/badge.svg)](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml)

| Phase | Scope | Status |
|---|---|---|
| Phase 0 — Foundation | Bash analyzer, SHA-256, AAPT metadata/permissions/manifest, ZIP inventory, optional signature/JADX hooks, local evidence files, `SUMMARY.md`, `tool-versions.txt` and report comparison | Implemented; regression-checked in the compatibility workflow |
| Phase 1 — Verified static foundation | Four-image CI matrix, regression tests, installation documentation, contributor workflow, static website and reproducible example report | Passed on Debian 12/13 and Ubuntu 22.04/24.04 in GitHub-hosted amd64 container jobs |
| Phase 2 — Static analysis expansion | APKTool integration, ELF/native inspection, dedicated DEX structural analysis and JSON/HTML report exports | Planned; not shipped |
| Phase 3 — Runtime analysis | Separate, controlled dynamic instrumentation and runtime-analysis effort | Planned; not shipped and outside the current static analyzer |

The [compatibility workflow](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml) is the stable source for current automated CI runs. CI covers GitHub-hosted Debian/Ubuntu amd64 containers only. It does not test physical Android devices, Termux itself, or Debian PRoot on Android. Reported working on one Android device (Debian 13 PRoot via Termux, maintainer-reported, single data point); no independent reports yet.

The Debian bootstrap installs YARA and binutils, but the analyzer does not run YARA scans or inspect ELF/native binaries. APKTool is installed by the compatibility workflow for package/tool checks but is not invoked by the analyzer. DEX/native-library archive paths are listed; no DEX structural analysis is performed.

The first public release, [v0.1.0](https://github.com/SHalimoosavi/SYJ-RE-Workstation/releases/tag/v0.1.0), was published on 2026-11-14.
