# Compatibility matrix

This page separates automated CI evidence from community-reported device tests. A row is not evidence for environments outside the one named.

[![Compatibility workflow](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml/badge.svg)](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml)

## Automated CI

The compatibility workflow executes package installation, Debian bootstrap, disposable fixture generation, analyzer regression tests, report artifact upload, Bash syntax checks and ShellCheck in GitHub-hosted amd64 Debian/Ubuntu containers.

| Environment | Image | Architecture | Package setup | Analyzer tests | Shell checks | Result |
|---|---|---|---|---|---|---|
| Debian 12 Bookworm | `debian:12` | amd64 | Passed | Passed | Passed | Passed |
| Debian 13 Trixie | `debian:13` | amd64 | Passed | Passed | Passed | Passed |
| Ubuntu 22.04 Jammy | `ubuntu:22.04` | amd64 | Passed | Passed | Passed | Passed |
| Ubuntu 24.04 Noble | `ubuntu:24.04` | amd64 | Passed | Passed | Passed | Passed |

See the [compatibility workflow and its individual runs](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml). The badge above reflects the workflow's live status; it is not a substitute for inspecting the four matrix jobs.

**Boundary:** CI covers GitHub-hosted Debian/Ubuntu amd64 containers only. It does not test a physical Android device, Termux itself, Debian PRoot on Android, ARM/ARM64 devices, or every package mirror and tool version. Termux and Debian PRoot on Android remain unverified until reproducible community reports are submitted and reviewed.

## Community-reported results

No independently submitted and reviewed Termux or Debian PRoot device reports have been recorded in this table yet. Do not interpret the absence of reports as a pass.

| Environment | Device | Android version | Architecture | Distribution / release | Commit tested | Result | Report |
|---|---|---|---|---|---|---|---|
| No community reports recorded yet | — | — | — | — | — | Not tested | — |

Community rows will be added only after a tester submits an [Environment test report](https://github.com/SHalimoosavi/SYJ-RE-Workstation/issues/new?template=environment-test-report.yml). Each row must link to its issue. Failed and partial reports remain visible; they are useful compatibility evidence.

## How to contribute a result

Use [GitHub Discussions](https://github.com/SHalimoosavi/SYJ-RE-Workstation/discussions) for questions, test coordination and discussion of community results. Follow [Testing on Android](testing-on-android.md), then submit the [Environment test report issue form](https://github.com/SHalimoosavi/SYJ-RE-Workstation/issues/new?template=environment-test-report.yml) with the exact commit, environment, architecture, tool versions, command output and sanitized logs. Never attach an APK or private report.
