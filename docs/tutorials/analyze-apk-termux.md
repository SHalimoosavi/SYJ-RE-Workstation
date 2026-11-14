# Analyze an APK using Termux and Debian PRoot

**Status: not yet CI-tested.** The repository's GitHub Actions compatibility workflow runs only in GitHub-hosted Debian/Ubuntu amd64 containers. It does not execute on Android, inside Termux, or inside Debian PRoot running on Android. Treat this tutorial as provisional until community members submit reproducible device-side reports.

## 1. Install Termux packages

In Termux:

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

Inside the Debian PRoot shell, run as root (the default PRoot-Distro login user is normally root):

```bash
apt-get update
apt-get install -y git bash ca-certificates file unzip zip coreutils grep aapt apksigner apktool default-jre-headless android-framework-res
```

AAPT is required by the analyzer. `apksigner` and JADX are optional analyzer integrations. APKTool is installed here only as a package; the repository does not invoke it.

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

Do not report success unless you completed the steps on a physical Android device. Include Android version, device architecture, Termux version, Debian PRoot distribution, package installation results, exact commands and sanitized errors. Do not include usernames, home paths, APK contents, private reports or personal data in a public report.

## Limitations

This is static evidence collection only. It does not execute APKs, provide a malware verdict, confirm vulnerabilities or prove an APK is safe. YARA, APKTool and ELF analysis are not implemented analyzer features. Termux and Debian PRoot results remain community-reported and unverified until reproducible reports are received and reviewed.
