# Security and privacy

## Authorization

Only analyze APKs you own or have explicit permission to assess. Respect applicable law, contracts, platform terms and third-party intellectual property.

## Evidence handling

APK files and analysis reports may contain proprietary code, API endpoints, personal information, tokens or internal infrastructure details. Keep them private. Do not upload them to public repositories or paste secrets into issues.

## Safe workflow

- Keep samples in a private input directory.
- Do not commit `*.apk`, `*.aab`, `*.dex`, decompiled output, certificates, keys or reports.
- Review `git status --ignored` and `git diff --cached` before pushing.
- Redact credentials from logs before sharing.
- Do not install or execute unknown samples on a personal device.
- Use an isolated test device/emulator for any separately authorized dynamic analysis.

## Limitations

A permission or manifest flag alone is not proof of a vulnerability. A successful signature verification proves integrity relative to the presented signing certificate, not that the publisher is trusted. Decompiler errors do not prove APK corruption or malicious behavior.
