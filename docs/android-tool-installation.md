# Android tool installation and compatibility

This guide distinguishes distribution package metadata from tests executed by this repository's CI. A package being listed in a distribution index does not prove that it installs or that the analyzer works on that release.

## Runtime requirements

The current analyzer requires Bash, `file`, `sha256sum`, `unzip` and AAPT (`aapt`). Signature verification with `apksigner` and DEX decompilation with JADX are optional. APKTool is currently a separately installed/manual utility; no shipped script invokes it.

JADX **v1.5.6** requires a 64-bit Java runtime **11 or newer** according to the upstream project documentation. Install the distribution's `default-jre-headless` metapackage rather than hard-coding Java 21: it resolves to the default supported runtime for each release.

## Exact JRE package per supported release

The package index dependency metadata identifies these runtime versions:

| Distribution | Install command | Runtime selected by `default-jre-headless` |
|---|---|---|
| Debian 12 Bookworm | `sudo apt-get install -y default-jre-headless` | OpenJDK 17 |
| Debian 13 Trixie | `sudo apt-get install -y default-jre-headless` | OpenJDK 21 |
| Ubuntu 22.04 Jammy | `sudo apt-get install -y default-jre-headless` | OpenJDK 11 |
| Ubuntu 24.04 Noble | `sudo apt-get install -y default-jre-headless` | OpenJDK 21 |

Sources: Debian Bookworm and Trixie package records and Ubuntu Jammy and Noble package records for `default-jre-headless`. See [Bookworm](https://packages.debian.org/bookworm/default-jre-headless), [Trixie](https://packages.debian.org/trixie/default-jre-headless), [Jammy](https://packages.ubuntu.com/jammy/default-jre-headless), and [Noble](https://packages.ubuntu.com/noble/default-jre-headless). These records describe the package dependency; the CI matrix below is the source of actual compatibility test status.

To install all required and optional Android tools plus the compatible JRE on any of these releases:

```bash
sudo apt-get update
apt-cache policy aapt apksigner apktool default-jre-headless
sudo apt-get install -y aapt apksigner apktool default-jre-headless
java -version
```

If `apt-cache policy` shows no candidate, check enabled official repositories and architecture before proceeding. Do not substitute an untrusted package source.

## Install JADX v1.5.6

The upstream JADX release provides the CLI archive. The project documents Java 11+ for 64-bit runtime environments. Use the same archive on all four distributions after installing their release-correct JRE above.

```bash
sudo apt-get install -y ca-certificates curl unzip
mkdir -p "$HOME/opt/jadx/1.5.6" "$HOME/.cache/jadx"
cd "$HOME/.cache/jadx"
curl -fL --proto '=https' --tlsv1.2 -o jadx-1.5.6.zip https://github.com/skylot/jadx/releases/download/v1.5.6/jadx-1.5.6.zip
unzip -q jadx-1.5.6.zip -d "$HOME/opt/jadx/1.5.6"
JADX_BIN="$(find "$HOME/opt/jadx/1.5.6" -type f -name jadx -print -quit)"
test -n "$JADX_BIN"
export PATH="$(dirname "$JADX_BIN"):$PATH"
jadx --version
```

This download command does not independently authenticate the ZIP asset. The upstream v1.5.6 release does not publish a SHA-256 checksum in its release assets. Do not call the archive checksum-verified. Upstream source tag signature verification is separate from verifying the downloaded release archive.

Upstream references: [JADX releases](https://github.com/skylot/jadx/releases/tag/v1.5.6) and [JADX README](https://github.com/skylot/jadx#readme).

## Compatibility matrix

Status is populated from GitHub Actions runs on the compatibility workflow. The status reflects compatibility workflow run [#6](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/runs/43548949633). Package installation, bootstrap and fixture build passed on all four images. The analyzer regression suite failed on all four because the fixture correctly contained no DEX/native-library entries, while the test incorrectly required the DEX inventory report to be non-empty. That assertion has since been corrected to accept an empty inventory file, but the corrected test has not yet run to completion in a fresh matrix. Overall compatibility remains Failed / not verified.

| Environment | Container image | Package installation | Bootstrap | APK integration | Overall |
|---|---|---|---|---|---|
| Debian 12 Bookworm | `debian:12` | Passed (run 6) | Passed (run 6) | Failed: empty DEX inventory assertion | Failed |
| Debian 13 Trixie | `debian:13` | Passed (run 6) | Passed (run 6) | Failed: empty DEX inventory assertion | Failed |
| Ubuntu 22.04 Jammy | `ubuntu:22.04` | Passed (run 6) | Passed (run 6) | Failed: empty DEX inventory assertion | Failed |
| Ubuntu 24.04 Noble | `ubuntu:24.04` | Passed (run 6) | Passed (run 6) | Failed: empty DEX inventory assertion | Failed |

A successful workflow job will be reported as Passed only for the steps that actually ran successfully. A failed job will remain Failed until the failure is fixed and a rerun succeeds. Architecture and Termux/Android-device compatibility are not covered by these amd64 container tests.

## Verify installed tools

```bash
command -v aapt apksigner apktool java
dpkg-query -W -f='${Package} ${Version}\\n' aapt apksigner apktool default-jre-headless
aapt version
apksigner version
apktool --version
java -version
```

## Scope and caveats

- AAPT is required by `scripts/analyze-apk.sh`.
- apksigner and JADX are optional integrations.
- APKTool is not currently called by the analyzer.
- A successful static collection run is not a malware verdict and does not prove an APK safe.
- CI container results do not prove compatibility on every CPU architecture, Android device, Termux version or PRoot configuration.
