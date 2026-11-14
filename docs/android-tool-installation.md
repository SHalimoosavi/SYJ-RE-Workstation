# Android tool installation and compatibility

This guide distinguishes package availability from analyzer functionality and from tests actually executed by CI.

[![Compatibility workflow](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml/badge.svg)](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml)

## Runtime requirements

The analyzer requires Bash, `file`, `sha256sum`, `unzip`, `grep` and AAPT (`aapt`). Signature verification with `apksigner` and decompilation with JADX are optional. APKTool is installed in the compatibility workflow for package/tool checks only; no analyzer script invokes it. The Debian bootstrap installs YARA and binutils, but the analyzer does not run YARA scans or inspect ELF/native binaries.

JADX **v1.5.6** requires a 64-bit Java runtime **11 or newer** according to the upstream project documentation. The CI matrix installs the distribution's `default-jre-headless` metapackage.

## Release-specific Java packages

| Distribution | Exact package command | Runtime |
|---|---|---|
| Debian 12 Bookworm | `sudo apt-get install -y openjdk-17-jre-headless` | OpenJDK 17 |
| Debian 13 Trixie | `sudo apt-get install -y openjdk-21-jre-headless` | OpenJDK 21 |
| Ubuntu 22.04 Jammy | `sudo apt-get install -y openjdk-11-jre-headless` | OpenJDK 11 |
| Ubuntu 24.04 Noble | `sudo apt-get install -y openjdk-21-jre-headless` | OpenJDK 21 |

Package-index references: [Debian Bookworm default JRE](https://packages.debian.org/bookworm/default-jre-headless) and [OpenJDK 17](https://packages.debian.org/bookworm/openjdk-17-jre-headless); [Debian Trixie default JRE](https://packages.debian.org/trixie/default-jre-headless) and [OpenJDK 21](https://packages.debian.org/trixie/openjdk-21-jre-headless); [Ubuntu Jammy default JRE](https://packages.ubuntu.com/jammy/default-jre-headless) and [OpenJDK 11](https://packages.ubuntu.com/jammy/openjdk-11-jre-headless); [Ubuntu Noble default JRE](https://packages.ubuntu.com/noble/default-jre-headless) and [OpenJDK 21](https://packages.ubuntu.com/noble/openjdk-21-jre-headless).

The compatibility jobs install `default-jre-headless` and verify the Java runtime selected by each distribution. The explicit commands above are the corresponding release-specific JRE packages for manual JADX setup. Confirm package candidates on the target system before installation:

```bash
sudo apt-get update
apt-cache policy openjdk-17-jre-headless openjdk-21-jre-headless openjdk-11-jre-headless
```

## Install JADX v1.5.6 (optional)

Install a 64-bit Java 11+ runtime first. Then download and unpack the official release archive:

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

[![Compatibility workflow](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml/badge.svg)](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/workflows/compat.yml)

The compatibility workflow runs package installation, Debian bootstrap, disposable APK fixture generation, analyzer regression tests, report artifact upload, Bash syntax checks and ShellCheck on the four GitHub-hosted amd64 container images:

| Environment | Container image | Package installation | Bootstrap | APK integration and tests | Overall |
|---|---|---|---|---|---|
| Debian 12 Bookworm | `debian:12` | Passed | Passed | Passed | Passed |
| Debian 13 Trixie | `debian:13` | Passed | Passed | Passed | Passed |
| Ubuntu 22.04 Jammy | `ubuntu:22.04` | Passed | Passed | Passed | Passed |
| Ubuntu 24.04 Noble | `ubuntu:24.04` | Passed | Passed | Passed | Passed |

**Boundary:** CI covers GitHub-hosted Debian/Ubuntu amd64 containers only. It does not run on a physical Android device, in Termux itself, or inside Debian PRoot on Android. Reported working on one Android device (Debian 13 PRoot via Termux, maintainer-reported, single data point); no independent reports yet. Other CPU architectures are also outside this matrix.

## Verify installed tools

```bash
command -v aapt apksigner java
aapt version
apksigner version
java -version
```

Run `apksigner version` only when apksigner is installed. JADX is optional; verify it separately with `jadx --version` after installing it.

## Scope and caveats

- AAPT is required by `scripts/analyze-apk.sh`.
- apksigner and JADX are optional integrations.
- APKTool is not invoked by the analyzer; there is no APKTool integration in this release.
- YARA is installed by the Debian bootstrap but is not used by the analyzer; no YARA scan or ruleset is run.
- binutils is installed by the Debian bootstrap, but no ELF/native binary parser or inspection pipeline is implemented.
- DEX/native-library archive paths are listed; DEX structure and ELF contents are not analyzed.
- JSON and HTML report exports are not implemented.
- A successful static collection run is not a malware verdict and does not prove an APK safe.
