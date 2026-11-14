# SYJ-RE Workstation

A mobile-first Android APK inspection and reverse-engineering toolkit for **Termux + Debian PRoot**. It wraps standard tools in repeatable workflows and keeps analysis evidence separate from the public source repository.

> **Status:** Initial public scaffold. The scripts are designed for static inspection. Dynamic instrumentation, emulator workflows, and complete cross-device validation are not included yet.

## Features

- APK identity, SHA-256, package/version and SDK metadata
- Permission inventory and decoded Android manifest
- APK signature verification (when `apksigner` is installed)
- APK archive inventory, DEX and native-library inventory
- Optional JADX decompilation with a preserved log; JADX errors do not erase other results
- Customer/worker or multi-build comparison using generated metadata
- Termux and Debian PRoot bootstrap helpers
- Reports stored locally and excluded from Git by default

## Safety and scope

Use this project only on applications you own or are authorized to assess. Static inspection does not prove exploitability or safety. Do not install or execute unknown APKs as part of this workflow.

**Never commit** APKs, extracted app contents, decompiled source, signing keys, API tokens, credentials, personal data, private reports, or client/customer artifacts. The `.gitignore` excludes common evidence paths and APK formats, but review `git status` before every push.

## Requirements

- Android device with Termux and shared-storage permission if you want to inspect files in Android storage
- Debian 13 (or compatible Debian) in PRoot-Distro
- Bash, `aapt`, `apksigner`, `apktool`, `jadx`, `unzip`, `sha256sum`
- Optional: `adb`, `objdump`, `readelf`, `gdb`, `yara`, `tshark`, `sqlite3`

Tool availability differs across architectures and distributions. JADX may fail to decompile Kotlin/Expo-generated methods while still extracting other classes. Treat its errors as decompiler limitations until independently verified.

## Quick start

### 1. Install Debian in Termux

```bash
pkg update && pkg upgrade
pkg install git proot-distro
proot-distro install debian
```

### 2. Clone this repository in Termux

```bash
git clone https://github.com/SHalimoosavi/SYJ-RE-Workstation.git
cd SYJ-RE-Workstation
```

### 3. Start Debian with the project and APK input directory mounted

```bash
mkdir -p "$HOME/rea-input"
proot-distro login debian --bind "$PWD:/mnt/syj-re" --bind "$HOME/rea-input:/mnt/apk-input"
```

Copy only APKs you are authorized to inspect into `~/rea-input` from Termux.

### 4. Install Debian dependencies

Inside Debian:

```bash
bash /mnt/syj-re/scripts/debian-bootstrap.sh
```

Install JADX, APKTool, AAPT and apksigner using trusted distribution or official release sources if they are not available from your package manager. Verify downloaded binaries and release checksums.

### 5. Analyze an APK

Inside Debian:

```bash
bash /mnt/syj-re/scripts/analyze-apk.sh /mnt/apk-input/example.apk
```

The script writes a report directory under:

```text
~/SYJ-RE-Workstation/reports/<apk-name>/
```

Reports are intentionally local and ignored by Git.

## Compare two builds

```bash
bash /mnt/syj-re/scripts/compare-reports.sh \
  ~/SYJ-RE-Workstation/reports/customer \
  ~/SYJ-RE-Workstation/reports/worker
```

This compares package metadata, permissions, file inventories and signing-certificate summaries where available. A difference is not automatically a vulnerability.

## Optional REA + Gemini integration

REA MCP and Gemini CLI are optional external tools. This repository does not bundle them, their credentials, or their output. Follow the upstream installation instructions and never commit API keys or MCP configuration containing secrets.

## Project layout

```text
SYJ-RE-Workstation/
├── scripts/
│   ├── analyze-apk.sh
│   ├── compare-reports.sh
│   ├── termux-bootstrap.sh
│   └── debian-bootstrap.sh
├── docs/
│   ├── architecture.md
│   ├── security-and-privacy.md
│   └── troubleshooting.md
├── .github/workflows/
│   └── shellcheck.yml
├── .gitignore
├── LICENSE
├── CONTRIBUTING.md
├── SECURITY.md
└── README.md
```

## Roadmap

- [x] Initial Termux + Debian PRoot workflow
- [x] APK metadata, manifest, permissions, signing and archive inventory
- [x] Optional JADX execution with error-log preservation
- [ ] Automated static checks for exported components and cleartext policy
- [ ] Native ELF inventory and metadata reporting
- [ ] HTML/JSON report export
- [ ] CI tests on Linux and shell linting
- [ ] Optional ADB-based runtime diagnostics
- [ ] Reproducible install and validation on multiple Android devices

## License

MIT. See [LICENSE](LICENSE).
