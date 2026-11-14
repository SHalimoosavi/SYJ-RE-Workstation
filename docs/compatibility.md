# Compatibility matrix

This page separates automated CI evidence from community-reported device tests. A row is not evidence for environments outside the one named.

[![Compatibility workflow](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml/badge.svg)](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml)

## Automated CI

The compatibility workflow executes package installation, Debian bootstrap, disposable fixture generation, analyzer regression tests, report artifact upload, Bash syntax checks and ShellCheck in GitHub-hosted amd64 Debian/Ubuntu containers. The table records the last completed matrix result; check the live workflow page for any newer run that is still pending or in progress.

| Environment | Image | Architecture | Package setup | Analyzer tests | Shell checks | Result |
|---|---|---|---|---|---|---|
| Debian 12 Bookworm | `debian:12` | amd64 | Passed | Passed | Passed | Passed |
| Debian 13 Trixie | `debian:13` | amd64 | Passed | Passed | Passed | Passed |
| Ubuntu 22.04 Jammy | `ubuntu:22.04` | amd64 | Passed | Passed | Passed | Passed |
| Ubuntu 24.04 Noble | `ubuntu:24.04` | amd64 | Passed | Passed | Passed | Passed |

See the [compatibility workflow and its individual runs](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml). The badge above reflects the workflow's live status; it is not a substitute for inspecting the four matrix jobs.

## Tool versions recorded by CI

The following values are copied from the generated `tool-versions.txt` artifacts produced by completed compatibility matrix jobs. They are observations from those jobs, not minimum-version requirements or promises that future package repositories will provide identical versions.

| Environment | AAPT | apksigner | JADX | Java |
|---|---|---|---|---|
| Debian 12 Bookworm | `0.2-debian` | `0.9` | unavailable | `17.0.21` |
| Debian 13 Trixie | `0.2-debian` | `0.9` | unavailable | `21.0.13` |
| Ubuntu 22.04 Jammy | `0.2-debian` | `0.9` | unavailable | `11.0.33` |
| Ubuntu 24.04 Noble | `0.2-debian` | `0.9` | unavailable | `21.0.13.0.3` |

Each job generated a sanitized tool-version record. JADX was unavailable in these fixture jobs, so its version is recorded as `unavailable`. The compatibility workflow page links to current and historical runs and artifacts.

**Boundary:** CI covers GitHub-hosted Debian/Ubuntu amd64 containers only. It does not test a physical Android device, Termux itself, Debian PRoot on Android, ARM/ARM64 devices, or every package mirror and tool version. Reported working on one Android device (Debian 13 PRoot via Termux, maintainer-reported, single data point); no independent reports yet.

## Maintainer-reported results

The following is one maintainer-reported device data point. It is not an independent community report or an independently reproduced verification. Device model, Android release, `uname -m` architecture, exact commit SHA and `tool-versions.txt` contents were not recorded.

| Environment | Device | Android version | Architecture | Distribution / release | Commit tested | Test results | Date | Report status |
|---|---|---|---|---|---|---|---|---|
| Termux + Debian 13 PRoot on Android | not recorded | not recorded | not recorded | Debian 13 Trixie; v0.1.0 | not recorded | `tests/test-workstation.sh`: passed (14 tests); `analyze-apk.sh`: completed on two real APKs; optional JADX stage: failed (exit code 3) | 2026-11-14 | Maintainer-reported; one device; not independently verified |

`tool-versions.txt` contents: not recorded. The optional JADX failure is recorded as a tool-stage failure; it does not change the fact that the analyzer completed its collection run.

## Community-reported results

No independent community reports have been submitted and reviewed yet. The maintainer-reported row above is a single data point and is not independent verification. Do not interpret it as evidence for other devices or architectures.

| Environment | Device | Android version | Architecture | Distribution / release | Commit tested | Result | Report |
|---|---|---|---|---|---|---|---|
| No community reports recorded yet | — | — | — | — | — | Not tested | — |

Community rows will be added only after a tester submits an [Environment test report](https://github.com/SHalimoosavi/SYJ-RE-Workstation/issues/new?template=environment-test-report.yml). Each row must link to its issue. Failed and partial reports remain visible; they are useful compatibility evidence.

## How to contribute a result

Use [GitHub Discussions](https://github.com/SHalimoosavi/SYJ-RE-Workstation/discussions) for questions, test coordination and discussion of community results. Follow [Testing on Android](testing-on-android.md), then submit the [Environment test report issue form](https://github.com/SHalimoosavi/SYJ-RE-Workstation/issues/new?template=environment-test-report.yml) with the exact commit, environment, architecture, tool versions, command output and sanitized logs. Never attach an APK or private report.
