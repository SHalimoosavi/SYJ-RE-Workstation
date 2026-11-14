# Security and privacy

## Authorization

Only analyze APKs you own or have explicit permission to assess. Respect applicable law, contracts, platform terms and third-party intellectual property. This policy is not legal advice.

## Evidence handling

APK files and analysis reports may contain proprietary code, API endpoints, personal information, tokens or internal infrastructure details. Keep them private. Do not upload them to public repositories or paste secrets into issues.

## Safe workflow

- Keep samples in a private input directory.
- Do not commit `*.apk`, `*.aab`, `*.dex`, decompiled output, certificates, keys or reports.
- Review `git status --ignored` and `git diff --cached` before pushing.
- Redact credentials from logs before sharing.
- Do not install or execute unknown samples on a personal device.
- Use an isolated test device or emulator for separately authorized dynamic analysis.

## Contact

For project and documentation questions, use the approved project contact address: [shalimoosavi@gmail.com](mailto:shalimoosavi@gmail.com).

## Limitations

A permission or manifest flag alone is not proof of a vulnerability. Successful signature verification establishes cryptographic consistency against the presented certificate; it does not establish publisher trust. Decompiler errors do not prove APK corruption or malicious behavior. This project does not classify malware or prove that an analyzed application is safe.
