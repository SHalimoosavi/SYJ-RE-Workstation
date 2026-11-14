# Project roadmap

This project is an early-stage Bash-based static APK inspection workstation. The phases below describe delivery status and future work; planned work is not implemented functionality. CI evidence is limited to GitHub-hosted Debian/Ubuntu amd64 containers, not physical Android, Termux itself, or Debian PRoot on Android. The Debian bootstrap installs YARA and binutils, but the analyzer does not run YARA scans or inspect ELF/native binaries. APKTool is installed by the compatibility workflow for package/tool checks but is not invoked by the analyzer.

| Phase | Scope | Status |
|---|---|---|
| Phase 0 — Foundation | Bash analyzer, SHA-256, AAPT metadata/permissions/manifest, ZIP inventory, optional signature/JADX hooks, local reports and report comparison | Implemented; regression-checked in compatibility workflow run [#90](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/runs/43551892781) |
| Phase 1 — Verified static foundation | Four-release CI matrix, regression tests, installation documentation, contributor workflow and reproducible example report | Passed on Debian 12/13 and Ubuntu 22.04/24.04 in GitHub-hosted amd64 container jobs in compatibility workflow run [#90](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/runs/43551892781). This CI does not test physical Android devices, Termux itself, or Debian PRoot on Android |
| Phase 2 — Static analysis expansion | APKTool integration, ELF/native inspection, dedicated DEX analysis and richer report formats | Planned; not shipped |
| Phase 3 — Runtime analysis | Separate, controlled dynamic instrumentation and runtime-analysis effort | Planned; not shipped and outside the current static analyzer |

The GitHub milestones are the authoritative progress tracker once maintainers create and assign them. A milestone is a planning container, not evidence of completion.
