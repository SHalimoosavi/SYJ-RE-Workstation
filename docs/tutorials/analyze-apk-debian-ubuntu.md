# Analyze an APK on Debian or Ubuntu

This beginner tutorial follows the same order as a clean Debian or Ubuntu installation: install prerequisites, clone the repository, build the repository's disposable APK fixture, then run the analyzer. The compatibility workflow tests GitHub-hosted Debian 12, Debian 13, Ubuntu 22.04 and Ubuntu 24.04 amd64 containers only. It does not establish compatibility on other distributions, architectures or Android environments.

[![Compatibility workflow](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml/badge.svg)](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml)

## 1. Install prerequisites

Open a root shell (or run these commands as root). Install Git before cloning:

```bash
apt-get update
apt-get install -y git bash ca-certificates file unzip zip coreutils grep aapt android-framework-res apksigner
```

The analyzer requires `file`, `sha256sum` (provided by coreutils), `unzip`, `grep` and `aapt`. `apksigner` is optional. The Android framework resource package is needed only to build the disposable test APK. APKTool, YARA and JADX are not required by this tutorial; APKTool integration and YARA scanning are not implemented analyzer features.

## 2. Clone the repository

```bash
git clone https://github.com/SHalimoosavi/SYJ-RE-Workstation.git
cd SYJ-RE-Workstation
```

## 3. Build the repository's disposable fixture

The committed manifest is `docs/sample-apk/AndroidManifest.xml`.

```bash
mkdir -p /tmp/syj-re-test
aapt package -f -M docs/sample-apk/AndroidManifest.xml -I /usr/share/android-framework-res/framework-res.apk -F /tmp/syj-re-test/syj-ci-fixture.apk
test -s /tmp/syj-re-test/syj-ci-fixture.apk
```

This is a minimal unsigned fixture built from the repository's manifest and the distribution's Android framework resources. It has no application code and is not a real application. If the framework resource file is not at that path on your distribution, locate the installed package's actual `framework-res.apk` before running the build command.

## 4. Run the analyzer

```bash
bash scripts/analyze-apk.sh /tmp/syj-re-test/syj-ci-fixture.apk
```

The analyzer writes a report beneath the workstation's reports directory. It includes raw evidence files, an evidence-only `SUMMARY.md`, and a sanitized `tool-versions.txt` record. Review the raw files alongside the summary; missing fields are marked `not available`, not inferred. A completed collection run is not a malware verdict or proof that the APK is safe.

## Scope

[![Compatibility workflow](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml/badge.svg)](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml)

CI covers GitHub-hosted Debian/Ubuntu amd64 containers only. It does not test physical Android devices, Termux itself or Debian PRoot on Android. Reported working on one Android device (Debian 13 PRoot via Termux, maintainer-reported, single data point); no independent reports yet. APKTool integration, ELF/native inspection, DEX structural analysis, YARA scanning, JSON/HTML exports and dynamic analysis are not implemented in this release.
