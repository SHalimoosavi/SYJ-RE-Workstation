# Android tool installation and compatibility

This guide separates package-index evidence from commands that have actually been installed and tested. The four clean-environment tests requested for Debian 12, Debian 13, Ubuntu 22.04 and Ubuntu 24.04 were **not completed** during this update. Do not interpret package-index presence as a successful installation or runtime test.

## Package names and repository versions

Package-index information below was checked against the Debian and Ubuntu package websites during this documentation update. Versions can change with updates, enabled repositories, architecture and mirror state. Run `apt-cache policy` on the target machine before installation.

| Environment | `aapt` | `apksigner` | `apktool` | Install test |
|---|---|---|---|---|
| Debian 12 Bookworm | `aapt` 1:10.0.0+r36-10 | `apksigner` 31.0.2-1 | `apktool` 2.7.0+dfsg-6+deb12u1 | Untested |
| Debian 13 Trixie | `aapt` 1:14~beta1-3 | `apksigner` 35.0.2-1 | `apktool` 2.7.0+dfsg-7 | Untested |
| Ubuntu 22.04 Jammy | `aapt` 1:10.0.0+r36-3 | `apksigner` 31.0.2-1 | `apktool` 2.5.0+dfsg.1-2build1 | Untested |
| Ubuntu 24.04 Noble | `aapt` 1:14~beta1-2build3 | `apksigner` 31.0.2-1ubuntu1 | `apktool` 2.7.0+dfsg-7 | Untested |

The listed Ubuntu package versions are package-index references, not proof that your configured mirrors currently expose the same candidates. Enable the Universe component where required. Debian package details: [aapt](https://packages.debian.org/trixie/aapt), [apksigner](https://packages.debian.org/trixie/apksigner), [apktool](https://packages.debian.org/trixie/apktool). Ubuntu package details: [aapt](https://packages.ubuntu.com/aapt), [apksigner](https://packages.ubuntu.com/noble/apksigner), [apktool](https://packages.ubuntu.com/apktool), and the [Jammy package index](https://packages.ubuntu.com/jammy/amd64/allpackages).

## Inspect candidates before installing

On Debian and Ubuntu, update package metadata and inspect the actual candidates:

```bash
sudo apt-get update
apt-cache policy aapt apksigner apktool
```

If the candidate versions are available from trusted configured repositories, install:

```bash
sudo apt-get install -y aapt apksigner apktool
```

Verify the installed commands and package versions:

```bash
command -v aapt apksigner apktool
dpkg-query -W -f='${Package} ${Version}\n' aapt apksigner apktool
aapt version
apksigner version
apktool --version
```

The analyzer requires `aapt`. `apksigner` is optional for the current analyzer. APKTool is currently a manual/optional tool and is not invoked by any shipped script.

## JADX: use the official upstream release

No reliable Debian or Ubuntu apt package for JADX was confirmed in the package-index research for this update. Do not assume `apt install jadx` is available. The upstream project publishes CLI and GUI archives at [skylot/jadx Releases](https://github.com/skylot/jadx/releases); the upstream README requires a 64-bit Java 11 or later runtime for the standard archive.

Example installation for the upstream v1.5.6 release:

```bash
sudo apt-get install -y ca-certificates curl unzip openjdk-21-jre-headless
mkdir -p "$HOME/opt/jadx" "$HOME/.cache/jadx"
cd "$HOME/.cache/jadx"
curl -fL --proto '=https' --tlsv1.2 -o jadx-1.5.6.zip https://github.com/skylot/jadx/releases/download/v1.5.6/jadx-1.5.6.zip
unzip -q jadx-1.5.6.zip -d "$HOME/opt/jadx"
```

Add the extracted `bin` directory to PATH (the archive extracts a versioned directory; inspect it first):

```bash
find "$HOME/opt/jadx" -maxdepth 3 -type f -name jadx -print
```

Then add the actual containing `bin` directory to your shell PATH. Verify:

```bash
jadx --version
```

### Integrity verification note

The upstream v1.5.6 release page shows a verified signed Git tag and commit (GPG key ID `47A4975761262B6A`). The release page does not expose a published SHA-256 checksum or signature for the `jadx-1.5.6.zip` asset. Therefore, a locally computed `sha256sum` is useful for recording the downloaded file but does **not** independently authenticate it. Verify the signed tag through Git if you have independently obtained and trusted the upstream signing key; do not describe the archive itself as checksum-verified unless upstream publishes a matching checksum/signature.

## Test status for this repository

| Environment | apt-cache policy run here | Package installation run here | Analyzer integration test |
|---|---|---|---|
| Debian 12 Bookworm | No | No | No |
| Debian 13 Trixie | Attempted, package-index update timed out before policy output | No | No |
| Ubuntu 22.04 Jammy | No | No | No |
| Ubuntu 24.04 Noble | No | No | No |

The current execution environment did not provide Docker or Podman, and its package-index update timed out. For that reason, this document deliberately marks all four clean-install tests as untested. Package versions above come from distribution package websites, not local apt installation runs.

## Optional tool scope

- **Required:** AAPT (`aapt`) for metadata, permissions and manifest extraction.
- **Optional:** apksigner (`apksigner`) for APK signature verification.
- **Optional/manual:** APKTool (`apktool`) for resource and smali decoding; no current project script invokes it.
- **Optional:** JADX (`jadx`) for DEX-to-Java decompilation; the analyzer records its output and exit status when installed.

The Debian bootstrap intentionally installs base utilities only. Keep Android analysis tools optional and install them explicitly after checking package provenance and target architecture.
