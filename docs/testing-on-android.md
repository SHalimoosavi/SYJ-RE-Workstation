# Testing on Android

This is a provisional guide for testing Termux + Debian PRoot on a physical Android device. It does not claim native Termux execution or verified device compatibility. No reproducible community device reports have been accepted yet. Allow extra time if Debian packages need to download.

## 1. Prepare Termux

In Termux:

```bash
pkg update
pkg install -y git proot-distro
git clone https://github.com/SHalimoosavi/SYJ-RE-Workstation.git
proot-distro install debian
```

Enter Debian with the repository mounted:

```bash
proot-distro login debian --bind "$HOME/SYJ-RE-Workstation:/mnt/syj-re"
```

## 2. Install the test dependencies

Inside Debian:

```bash
apt-get update
apt-get install -y git bash file unzip coreutils grep aapt android-framework-res shellcheck
cd /mnt/syj-re
```

AAPT and the framework resource package are required to build the disposable test APK. The test suite does not need a third-party application APK.

## 3. Build the fixture and run the tests

```bash
aapt package -f -M docs/sample-apk/AndroidManifest.xml -I /usr/share/android-framework-res/framework-res.apk -F /tmp/syj-ci-fixture.apk
SYJ_TEST_APK=/tmp/syj-ci-fixture.apk bash tests/test-workstation.sh
bash -n scripts/*.sh tests/*.sh
shellcheck scripts/*.sh tests/*.sh
```

The fixture is generated from the repository's original minimal manifest and the Debian package's Android framework resources. It is unsigned and contains no application code.

## 4. Capture environment details

Run the relevant commands and copy their output into the issue form:

```bash
uname -m
bash --version | head -n 1
aapt version
file --version | head -n 1
unzip -v | head -n 1
command -v apksigner >/dev/null 2>&1 && apksigner version || echo "apksigner: unavailable"
command -v jadx >/dev/null 2>&1 && jadx --version || echo "jadx: unavailable"
command -v java >/dev/null 2>&1 && java -version 2>&1 | head -n 1 || echo "java: unavailable"
```

For Android version, run this in Termux before entering Debian:

```bash
getprop ro.build.version.release
getprop ro.build.version.sdk
```

Record the exact repository commit inside Debian with:

```bash
git -C /mnt/syj-re rev-parse HEAD
```

## 5. Submit a report

For setup questions, device-specific discussion and test coordination, use [GitHub Discussions](https://github.com/SHalimoosavi/SYJ-RE-Workstation/discussions). Submit reproducible results through the [Environment test report issue form](https://github.com/SHalimoosavi/SYJ-RE-Workstation/issues/new?template=environment-test-report.yml). Include:

- Environment type: Termux + Debian PRoot on Android.
- Device model, Android release and CPU architecture.
- Debian release and repository commit.
- Tool versions and the exact commands executed.
- Pass, fail or partial result, plus sanitized logs.

Remove usernames, home-directory paths, private APK names, personal information, tokens and credentials. Do not upload APKs, decompiled files or generated reports.

## What this test does not establish

A passing test on one phone does not establish compatibility on every Android device or architecture. GitHub CI separately covers only the four named GitHub-hosted amd64 Debian/Ubuntu container images. Termux and Debian PRoot on Android remain unverified until reproducible community reports are submitted and reviewed. The project remains early-stage and performs static evidence collection only; it is not a malware detector or proof of APK safety.
