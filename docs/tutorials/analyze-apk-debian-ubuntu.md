# Analyze an APK on Debian or Ubuntu

This tutorial documents the repository's GitHub Actions container workflow. The commands below are exercised by the compatibility workflow on GitHub-hosted Debian 12, Debian 13, Ubuntu 22.04 and Ubuntu 24.04 amd64 containers. They do not establish compatibility on other distributions, architectures or Android environments.

## 1. Install the packages used by CI

Run as root (or from a root shell):

```bash
apt-get update
apt-get install -y git bash ca-certificates file unzip zip coreutils grep aapt apksigner apktool default-jre-headless android-framework-res
```

The analyzer requires `file`, `sha256sum`, `unzip`, `grep` and `aapt`. The other packages are present in the CI environment for compatibility and optional-tool reporting. APKTool is not invoked by the analyzer.

## 2. Get the source

```bash
git clone https://github.com/SHalimoosavi/SYJ-RE-Workstation.git
cd SYJ-RE-Workstation
```

## 3. Build the repository's disposable fixture

```bash
mkdir -p /tmp/syj-re-test
aapt package -f -M docs/sample-apk/AndroidManifest.xml -I /usr/share/android-framework-res/framework-res.apk -F /tmp/syj-re-test/syj-ci-fixture.apk
test -s /tmp/syj-re-test/syj-ci-fixture.apk
```

This is a minimal unsigned fixture built from the repository's manifest and the distribution's Android framework resources. It has no application code and is not a real application.

## 4. Run the analyzer

```bash
bash scripts/analyze-apk.sh /tmp/syj-re-test/syj-ci-fixture.apk
```

The analyzer writes a report beneath the workstation's reports directory. Review the raw evidence files. The generated summary and tool-version record are planned for v0.2.0 and are not available on the current main branch. A completed collection run is not a malware verdict or proof that the APK is safe.

## Scope

CI covers GitHub-hosted Debian/Ubuntu amd64 containers only. It does not test physical Android devices, Termux itself or Debian PRoot on Android. Those environments require separate community reports. YARA, APKTool and ELF analysis are not implemented analyzer features; where present in the CI image or installation plan, they are dependencies or planned work only.
