# Read an SYJ-RE-Workstation report

SYJ-RE-Workstation collects static evidence from an APK. A report is a set of observations and tool outputs, not a malware verdict, vulnerability confirmation or proof of safety.

## Start with the raw evidence files

- `REPORT-INFO.txt` records report context. Treat its input path as local metadata and do not publish it without reviewing it for personal information.
- `file.txt`, `size.txt` and `sha256.txt` identify the input file and record its digest.
- `badging.txt`, `permissions.txt` and `manifest-tree.txt` contain AAPT output.
- `archive-files.txt` and `dex-and-native-libraries.txt` list archive entries and matching DEX/native-library paths.
- `signature.txt` contains signature-verification output or a skipped status.
- `jadx-status.txt` records optional JADX execution status. `jadx.log` and the `jadx/` output directory are created when JADX is installed and invoked.

## Interpret missing and failed results carefully

A missing evidence file or an empty field means the corresponding observation was not collected; it is not a zero value and must not be guessed. A signature check marked skipped means verification did not run. A failed signature check is an observation from the signing tool, not by itself a malware determination. A skipped or failed JADX step does not erase other evidence.

## Keep raw evidence together

Preserve the raw evidence files when sharing a report so reviewers can verify the underlying observations. Remove local paths and other personal data before sharing. Never upload an APK or report containing proprietary or private information without authorization.

## Scope

The project is early-stage and performs static evidence collection only. CI covers GitHub-hosted Debian/Ubuntu amd64 containers. Termux and Debian PRoot on Android are not CI-tested and require community reports. YARA, APKTool and ELF analysis are not implemented analyzer features; they are installed or planned only where explicitly documented.
