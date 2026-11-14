# Project roadmap

This project is an early-stage Bash-based static APK inspection workstation. The phases below describe delivery status and future work; planned work is not implemented functionality.

| Phase | Scope | Status |
|---|---|---|
| Phase 0 — Foundation | Bash analyzer, SHA-256, AAPT metadata/permissions/manifest, ZIP inventory, optional signature/JADX hooks, local reports and report comparison | Implemented in repository; compatibility validation pending |
| Phase 1 — Verified static foundation | Four-release CI matrix, regression tests, installation documentation, contributor workflow and reproducible example report | Verified on Debian 12/13 and Ubuntu 22.04/24.04 amd64 containers in CI run #31; other architectures and Termux remain unverified |
| Phase 2 — Static analysis expansion | APKTool integration, ELF/native inspection, dedicated DEX analysis and richer report formats | Planned; not shipped |
| Phase 3 — Runtime analysis | Separate, controlled dynamic instrumentation and runtime-analysis effort | Planned; not shipped and outside the current static analyzer |

The GitHub milestones are the authoritative progress tracker once maintainers create and assign them. A milestone is a planning container, not evidence of completion.
