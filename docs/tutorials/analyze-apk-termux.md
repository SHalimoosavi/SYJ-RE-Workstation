# Analyze an APK using Termux and Debian PRoot

<badge>Not yet CI-tested</badge>

**Status: not yet CI-tested.** The repository's GitHub Actions compatibility workflow runs only in GitHub-hosted Debian/Ubuntu amd64 containers. It does not execute on Android, inside Termux, or inside Debian PRoot running on Android. Do not treat the commands below as verified device compatibility. This tutorial remains provisional until community members submit reproducible device-side reports.

## 1. Install Termux packages

In Termux:

```bash
pkg update
pkg install -y git proot-distro
```

## 2. Clone the repository

```bash
git clone https://github.com/SHalimoosavi/SYJ-RE-Workstation.git
cd SYJ-RE-Workstation
```

## 3. Install and enter Debian PRoot

```bash
proot-distro install debian
proot-distro login debian --bind "$PWD:/mnt/syj-re"
```

Inside Debian, install the analyzer's required packages using the Debian package instructions in [the Debian/Ubuntu tutorial](analyze-apk-debian-ubuntu.md). Confirm the Android framework resource package path on the installed distribution before building the fixture.

## 4. Report what happened

Do not report success unless you actually completed the steps on a physical Android device. Include the Android version, device architecture, Termux version, Debian PRoot distribution, package installation results, exact commands, and sanitized error output. Do not include usernames, home paths, APK contents, private reports or personal data in a public report.

## Limitations

This is static evidence collection only. It does not execute APKs, provide a malware verdict, confirm vulnerabilities or prove an APK is safe. YARA, APKTool and ELF analysis are not implemented analyzer features. Termux and Debian PRoot results remain community-reported and unverified until reproducible reports are received and reviewed.
