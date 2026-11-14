# Changelog

All notable changes to SYJ-RE-Workstation are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow Semantic Versioning.

## [0.1.0] - 2026-11-14

### Added
- Initial Bash-based APK static inspection workflow.
- APK metadata, permission, manifest, archive inventory and SHA-256 report collection.
- Optional apksigner verification and JADX decompilation.
- Report comparison helper.
- Termux and Debian bootstrap scripts.
- Shell syntax and ShellCheck GitHub Actions workflow.
- Architecture, security, troubleshooting and installation documentation.

### Notes
- This is an early prototype release record, not a claim of broad platform validation.
- GitHub Actions compatibility run [#31](https://github.com/SHalimoosavi/SYJ-RE-Workstation/actions/runs/43549803520) passed package installation, bootstrap, fixture generation, analyzer tests, artifact upload, Bash syntax checks and ShellCheck on Debian 12, Debian 13, Ubuntu 22.04 and Ubuntu 24.04 (amd64 containers).
- These results are from GitHub-hosted Debian/Ubuntu amd64 container images only. CI does not cover physical Android devices, real Termux installations, or Debian PRoot on Android; those require separate on-device validation. Other CPU architectures, dynamic analysis and any safety/malware verdict are also outside this CI result.
- The repository remains early-stage. This changelog entry is not itself a published GitHub Release or tag.
