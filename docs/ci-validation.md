# CI validation scope

The compatibility workflow builds a disposable APK from a minimal Android manifest using the target distribution's AAPT and packaged framework resources. The fixture is generated inside the workflow, is not sourced from a third-party APK, and is not committed to Git.

The workflow installs AAPT, apksigner, APKTool and the distribution's `default-jre-headless`, executes the Debian bootstrap, runs the analyzer regression suite, checks shell syntax and runs ShellCheck. A report artifact is uploaded from each successful matrix job for review.

Compatibility status is based only on completed GitHub Actions jobs. A queued or in-progress job is not a pass. Container results cover the listed x86_64 images only; they do not validate Termux, Android devices or other architectures.
