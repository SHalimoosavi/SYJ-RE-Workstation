# SYJ-RE-Workstation launch kit

**Status: internal drafts only. Nothing in this file has been posted or scheduled.**

## Project description

SYJ-RE-Workstation is an early-stage open-source Bash toolkit for collecting static evidence from Android APK files on supported Debian-compatible Linux environments. It records package metadata, permissions, manifest output, archive inventory and optional signature/JADX results.

## Discussions welcome post — draft

**Title:** Welcome to SYJ-RE-Workstation Discussions

Welcome. This is the place to discuss the early-stage SYJ-RE-Workstation project, ask questions about its static APK evidence workflow, share documentation feedback and suggest focused improvements.

Please include reproducible details when reporting environment behavior. CI currently covers GitHub-hosted Debian/Ubuntu amd64 containers only: Debian 12, Debian 13, Ubuntu 22.04 and Ubuntu 24.04. Termux and Debian PRoot on Android are not CI-tested; those results must be community-reported with device and environment details.

The project collects static evidence only. It is not a malware verdict or proof that an APK is safe. YARA, APKTool and ELF analysis are not implemented analyzer features; they are installed or planned only where documented.

Please do not post APKs, private reports, credentials, personal data or material you are not authorized to share.

## Call-for-testers post — draft

**Title:** Help report real-device compatibility for SYJ-RE-Workstation

SYJ-RE-Workstation is an early-stage Bash project for static APK evidence collection. The current GitHub Actions matrix tests GitHub-hosted Debian/Ubuntu amd64 containers only.

We are looking for careful community reports from:
- Termux on physical Android devices
- Debian PRoot running on Android

These environments are not CI-tested. Please report your device model (only if you are comfortable sharing it), Android version, CPU architecture, Termux version, PRoot distribution, package installation results, exact commands and sanitized errors. A report should distinguish completed steps from failures and should not claim broader compatibility from one device.

The tool does not execute APKs, provide a malware verdict or prove safety. Test only APKs you own or are authorized to assess. Do not upload APKs, private reports, credentials or personal information.

## Short social post — draft

SYJ-RE-Workstation is an early-stage open-source Bash project for static Android APK evidence collection. CI currently covers GitHub-hosted Debian/Ubuntu amd64 containers only. Termux and Debian PRoot on Android still need community-reported validation. Static evidence is not a malware verdict or proof of safety.

## Release notes wording — draft

This is an early-stage development update, not a production security certification. The current scope is static APK evidence collection and report generation. GitHub-hosted Debian/Ubuntu amd64 CI coverage does not establish Android, Termux or Debian PRoot compatibility. YARA, APKTool and ELF analysis are not implemented analyzer features.

## Publication checklist

- [ ] Review all factual claims against the repository and live CI.
- [ ] Confirm current workflow run links and results before publishing.
- [ ] Keep Android/Termux status labelled not yet CI-tested until community reports are received and reviewed.
- [ ] Remove private information from any example output.
- [ ] Obtain explicit project-owner approval before posting.
