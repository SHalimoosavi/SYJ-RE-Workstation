# Compatibility matrix

This page separates automated CI evidence from community-reported device tests. A row is not evidence for environments outside the one named.

## Automated CI

The reference run below completed all four matrix jobs successfully. It ran on GitHub-hosted amd64 Debian/Ubuntu containers and executed package installation, Debian bootstrap, disposable fixture generation, analyzer regression tests, report artifact upload, Bash syntax checks and ShellCheck.

| Environment | Image | Architecture | Package setup | Analyzer tests | Shell checks | Result |
|---|---|---|---|---|---|---|
| Debian 12 Bookworm | `debian:12` | amd64 | Passed | Passed | Passed | Passed |
| Debian 13 Trixie | `debian:13` | amd64 | Passed | Passed | Passed | Passed |
| Ubuntu 22.04 Jammy | `ubuntu:22.04` | amd64 | Passed | Passed | Passed | Passed |
| Ubuntu 24.04 Noble | `ubuntu:24.04` | amd64 | Passed | Passed | Passed | Passed |

Evidence: [Compatibility workflow run #91](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/runs/43552228481), completed successfully on the PR head. The run's jobs are container jobs hosted by GitHub Actions.

**Boundary:** CI covers GitHub-hosted amd64 containers using the four images above. It does not test a physical Android device, Termux itself, Debian PRoot on Android, ARM/ARM64 devices, or every package mirror and tool version.

## Community-reported results

No independently submitted Termux or Debian PRoot device reports have been recorded in this table yet. Do not interpret the absence of reports as a pass.

| Environment | Device | Android version | Architecture | Distribution / release | Commit tested | Result | Report |
|---|---|---|---|---|---|---|---|
| No community reports recorded yet | — | — | — | — | — | Not tested | — |

Community rows will be added only after a tester submits an [Environment test report](https://github.com/SHalimoosavi/SYJ-RE-Workstation/issues/new?template=environment-test-report.yml). Each row must link to its issue. Failed and partial reports remain visible; they are useful compatibility evidence.

## How to contribute a result

Follow [Testing on Android](testing-on-android.md), then submit the issue form with the exact commit, environment, architecture, tool versions, command output and sanitized logs. Never attach an APK or private report.
