# Troubleshooting

## AAPT is missing

The analyzer requires the `aapt` executable. Install the distribution package named `aapt` when available, then check `apt-cache policy aapt` and `command -v aapt`. See [Android tool installation](android-tool-installation.md). The bootstrap script does not install it.

## apksigner or JADX was skipped

Both tools are optional for the current analyzer. Install apksigner from a trusted distribution package or JADX from the official upstream release, then verify that the executable is on `PATH`.

## JADX reports errors

JADX may fail on Kotlin coroutine, inline or generated Expo/React Native methods. Preserve `jadx.log`; use AAPT, archive inventory, APKTool and other independent evidence. Do not interpret the error count as a vulnerability count.

## APK has no assets directory or JavaScript bundle

Some React Native debug builds load JavaScript from a Metro development server. This is a hypothesis until confirmed from manifest metadata, application logs, source configuration or controlled runtime testing.

## ADB shows no devices

If `adb devices -l` lists no devices, no ADB target is currently connected and authorized. PRoot alone does not create an emulator or Android device connection.

## PRoot limitations

Debian PRoot is not a VM and cannot provide a separate kernel, hardware virtualization, cgroups or all Android device interfaces. Some tools may run with reduced functionality.
