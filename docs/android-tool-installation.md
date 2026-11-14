# Android tool installation and compatibility

This guide distinguishes distribution package metadata from tests executed by this repository's CI. A package being listed in a distribution index does not prove that it installs or that the analyzer works on that release.

## Runtime requirements

The current analyzer requires Bash, `file`, `sha256sum`, `unzip` and AAPT (`aapt`). Signature verification with `apksigner` and DEX decompilation with JADX are optional. APKTool is currently a separately installed/manual utility; no shipped script invokes it.

JADX **v1.5.6** requires a 64-bit Java runtime **11 or newer** according to the upstream project documentation. Install the distribution's `default-jre-headless` metapackage rather than hard-coding Java 21: it resolves to the default supported runtime for each release.

## Exact JRE package per supported release

JADX v1.5.6 requires a 64-bit Java runtime version 11 or newer.

| Distribution | Exact package command | Runtime |
|---|---|---|
| Debian 12 Bookworm | `sudo apt-get install -y openjdk-17-jre-headless` | OpenJDK 17 |
| Debian 13 Trixie | `sudo apt-get install -y openjdk-21-jre-headless` | OpenJDK 21 |
| Ubuntu 22.04 Jammy | `sudo apt-get install -y openjdk-11-jre-headless` | OpenJDK 11 |
| Ubuntu 24.04 Noble | `sudo apt-get install -y openjdk-21-jre-headless` | OpenJDK 21 |

Package-index references: [Debian Bookworm default JRE](https://packages.debian.org/bookworm/default-jre-headless) and [OpenJDK 17](https://packages.debian.org/bookworm/openjdk-17-jre-headless); [Debian Trixie default JRE](https://packages.debian.org/trixie/default-jre-headless) and [OpenJDK 21](https://packages.debian.org/trixie/openjdk-21-jre-headless); [Ubuntu Jammy default JRE](https://packages.ubuntu.com/jammy/default-jre-headless) and [OpenJDK 11](https://packages.ubuntu.com/jammy/openjdk-11-jre-headless); [Ubuntu Noble default JRE](https://packages.ubuntu.com/noble/default-jre-headless) and [OpenJDK 21](https://packages.ubuntu.com/noble/openjdk-21-jre-headless).

The CI matrix installs `default-jre-headless` and verifies the release-selected Java runtime in each container. These explicit package commands install the same release-default runtime when configuring JADX manually. Confirm candidates on the target machine:

```bash
sudo apt-get update
apt-cache policy openjdk-17-jre-headless openjdk-21-jre-headless openjdk-11-jre-headless
```

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

The completed GitHub Actions compatibility run [#31](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/runs/43549803520) passed all four amd64 container jobs. Each job completed package installation, Debian bootstrap, disposable APK fixture generation, analyzer regression tests, report artifact upload, Bash syntax checks and ShellCheck.

| Environment | Container image | Package installation | Bootstrap | APK integration and tests | Overall |
|---|---|---|---|---|---|
| Debian 12 Bookworm | `debian:12` | Passed | Passed | Passed | Passed |
| Debian 13 Trixie | `debian:13` | Passed | Passed | Passed | Passed |
| Ubuntu 22.04 Jammy | `ubuntu:22.04` | Passed | Passed | Passed | Passed |
| Ubuntu 24.04 Noble | `ubuntu:24.04` | Passed | Passed | Passed | Passed |

These results come exclusively from GitHub-hosted Actions jobs running the listed x86_64 Debian/Ubuntu container images. The jobs do not run on a physical Android device, in Termux itself, or inside Debian PRoot on Android. Therefore, CI does not verify real-device Termux compatibility or Debian PRoot compatibility; those require separate on-device testing. Other CPU architectures are also outside this matrix. The first matrix run failed due to a test assertion about an empty DEX inventory; that assertion was corrected, and run #31 is the successful rerun.

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
- CI runs in GitHub-hosted Debian/Ubuntu container images only. It does not test physical Android devices, Termux itself, or Debian PRoot on Android.
- Compatibility with real Android Termux and Debian PRoot must be validated separately on-device; neither is covered by the CI matrix.
