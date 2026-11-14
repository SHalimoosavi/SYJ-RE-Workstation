
# Analyze an APK using Termux and Debian PRoot

**Device compatibility is unverified.** The repository's GitHub Actions compatibility workflow runs only in GitHub-hosted Debian/Ubuntu amd64 containers. It does not execute on Android, inside Termux, or inside Debian PRoot running on Android. Treat this tutorial as provisional until reproducible community device reports are submitted and reviewed.

[![Compatibility workflow](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml/badge.svg)](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml)

## 1. Install Termux packages

In Termux, update package indexes and install Git and PRoot-Distro before cloning:

```bash
pkg update
pkg install -y git proot-distro
```

## 2. Clone the repository

Still in Termux:

```bash
git clone https://github.com/SHalimoosavi/SYJ-RE-Workstation.git
cd SYJ-RE-Workstation
```

## 3. Install Debian PRoot and enter it with the repository mounted

In Termux, from the cloned repository directory:

```bash
proot-distro install debian
proot-distro login debian --bind "$PWD:/mnt/syj-re"
```

The login command opens a shell inside Debian. The repository is available there at `/mnt/syj-re`.

## 4. Install dependencies inside Debian

Inside the Debian PRoot shell, install Git (needed for the commit-identification command), the analyzer dependencies and AAPT's framework resources:

```bash
apt-get update
apt-get install -y git bash ca-certificates file unzip coreutils grep aapt android-framework-res
```

AAPT is required by the analyzer. `apksigner` and JADX are optional integrations and are not required for this fixture walkthrough. APKTool is not invoked by the analyzer and is not required.

## 5. Build the disposable fixture and run the analyzer

Still inside Debian:

```bash
cd /mnt/syj-re
mkdir -p /tmp/syj-re-test
aapt package -f -M docs/sample-apk/AndroidManifest.xml -I /usr/share/android-framework-res/framework-res.apk -F /tmp/syj-re-test/syj-ci-fixture.apk
test -s /tmp/syj-re-test/syj-ci-fixture.apk
bash scripts/analyze-apk.sh /tmp/syj-re-test/syj-ci-fixture.apk
```

If the framework resource file is not at the documented path on the installed distribution, locate the package's actual framework resource file before running the fixture-build command.

## 6. Report what happened

Do not report success unless you completed the steps on a physical Android device. Include Android version, device architecture, Termux version, Debian PRoot distribution, package installation results, exact commands and sanitized errors. Do not include usernames, home paths, APK contents, private reports or personal data in a public report. Use [GitHub Discussions](https://github.com/SHalimoosavi/SYJ-RE-Workstation/discussions) for setup questions and the [Environment test report issue form](https://github.com/SHalimoosavi/SYJ-RE-Workstation/issues/new?template=environment-test-report.yml) for reproducible results.

## Limitations

This is static evidence collection only. It does not execute APKs, provide a malware verdict, confirm vulnerabilities or prove an APK is safe. APKTool integration, YARA scanning, ELF/native inspection, DEX structural analysis, JSON/HTML exports and dynamic analysis are not implemented analyzer features. Termux and Debian PRoot results remain unverified until reproducible community reports are received and reviewed.
