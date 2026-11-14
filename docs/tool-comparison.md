# Tool comparison and project boundaries

SYJ-RE-Workstation is a small Bash workflow for collecting a repeatable set of local APK evidence files. It is intended to sit alongside specialist Android tools, not replace them.

The current analyzer calls `file`, `sha256sum`, `unzip` and the legacy `aapt` executable. It can optionally call `apksigner` and JADX. It does not call MobSF or Apktool. It does not invoke AAPT2.

## Comparison

| Tool | Officially documented role | What it provides beyond this repository | Relationship to SYJ-RE-Workstation |
|---|---|---|---|
| [MobSF](https://github.com/MobSF/Mobile-Security-Framework-MobSF) · [documentation](https://mobsf.github.io/docs/) | Mobile application security research platform with static and dynamic analysis for Android, iOS and Windows Mobile, plus APIs and CLI integration. | A broader mobile security assessment platform, including runtime analysis, device/emulator workflows, traffic inspection and additional application formats. | Use MobSF when you need a full mobile security assessment workflow. This repository only collects a limited set of static evidence and is not a MobSF substitute. |
| [Apktool](https://apktool.org/) · [documentation](https://apktool.org/docs/) | Android APK reverse-engineering tool for decoding resources and manifest data, disassembling DEX to smali and rebuilding APKs. | Resource decoding, smali-level inspection and APK rebuilding workflows. | Use Apktool for resource/smali reverse engineering or rebuilding. The current analyzer does not invoke Apktool. |
| [JADX](https://github.com/skylot/jadx) · [README and documentation](https://github.com/skylot/jadx#readme) | Command-line and GUI tools for decompiling DEX/APK inputs to Java-like source and decoding manifest/resources. | Interactive GUI exploration, source navigation, search, deobfuscation and broader decompilation workflows. JADX itself notes that it cannot decompile all code in many cases. | The analyzer can invoke JADX CLI when installed and records its status/log. Use JADX directly for interactive decompilation and source exploration. |
| [AAPT](https://developer.android.com/training/multiple-apks/api) · [AAPT2 documentation](https://developer.android.com/tools/aapt2) | Android packaging/build tooling. Android's documentation describes AAPT's APK inspection commands and AAPT2's resource compile/link/dump workflow. | Direct access to Android packaging and manifest/resource inspection commands. AAPT2 is the newer tool and is not the same executable as the legacy `aapt` used by this repository. | AAPT is a required dependency for the current analyzer's badging, permissions and manifest-tree output. Use the Android tools directly for deeper build/resource work. |

## What this project contributes

- A single Bash entry point that coordinates a fixed sequence of existing command-line tools.
- A local report directory containing file identity, SHA-256, AAPT output, archive inventory, optional signature output and optional JADX status.
- A separate report-comparison helper.
- Debian and Termux bootstrap helpers, with Debian PRoot used as the documented Android environment.

This is an evidence-collection workflow. It does not provide a malware verdict, dynamic sandbox, vulnerability confirmation, complete reverse-engineering workflow or proof that an APK is safe.

## Choose the right tool for the task

- Choose **MobSF** for a broader mobile application security assessment and supported dynamic-analysis workflows.
- Choose **Apktool** when you need decoded Android resources, smali output or APK rebuilding.
- Choose **JADX** when you need Java-like decompilation and GUI-based code navigation.
- Choose **AAPT/AAPT2** when you need direct Android package, manifest or resource inspection.
- Use **SYJ-RE-Workstation** when a small Bash workflow and a repeatable local evidence directory are useful alongside those specialist tools.

These tools solve overlapping but different problems. This table describes documented scope, not benchmark results. No performance, completeness or superiority claim is made.

## Official references

- [MobSF project](https://github.com/MobSF/Mobile-Security-Framework-MobSF) · [MobSF documentation](https://mobsf.github.io/docs/)
- [Apktool project and documentation](https://apktool.org/)
- [JADX project and README](https://github.com/skylot/jadx)
- [Android AAPT inspection guide](https://developer.android.com/training/multiple-apks/api) · [Android AAPT2 documentation](https://developer.android.com/tools/aapt2)
