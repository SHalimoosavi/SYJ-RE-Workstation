# Architecture

SYJ-RE Workstation is a thin orchestration layer around established Android and Linux inspection utilities.

1. **Termux host:** obtains APKs and launches Debian PRoot.
2. **Debian PRoot:** provides a Linux userspace and the analysis toolchain. It does not change the Android device's CPU architecture or provide a full virtual machine.
3. **Static analyzer script:** records APK metadata, permissions, manifest tree, archive inventory, signature verification and optional JADX output.
4. **Local evidence directory:** stores per-APK reports outside the public Git repository.

## Design principles

- Preserve original APKs; analyze copies or read-only inputs.
- Keep generated reports out of source control by default.
- Treat each tool's output as evidence, not a final security conclusion.
- Make optional tools fail gracefully without discarding independent results.
- Never execute an APK as part of static analysis.
