# Article draft: An early-stage static APK evidence workstation

**Publication status: draft only — not posted.**

SYJ-RE-Workstation is an early-stage, open-source Bash project for collecting static evidence from Android APK files. It coordinates existing command-line tools to record file identity, SHA-256, package metadata, permissions, manifest output and archive inventory. Signature verification and JADX output are conditional on those tools being available.

The project is deliberately narrower than a complete mobile application security platform. It does not execute APKs, provide a malware verdict, confirm vulnerabilities or prove that an application is safe. Its reports are evidence for a person to inspect and interpret.

The current compatibility workflow covers GitHub-hosted Debian/Ubuntu amd64 containers, specifically Debian 12, Debian 13, Ubuntu 22.04 and Ubuntu 24.04. This CI coverage does not establish compatibility on physical Android devices, Termux itself or Debian PRoot running on Android. Those results must come from reproducible community reports.

YARA, APKTool and ELF analysis must not be presented as implemented analyzer capabilities. They are installed or planned only where the project documentation explicitly says so. The project remains early-stage, and its documentation and compatibility evidence are still being expanded.

**Project:** https://github.com/SHalimoosavi/SYJ-RE-Workstation
