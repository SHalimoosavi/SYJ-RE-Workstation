# Troubleshooting

## JADX reports errors

JADX may fail on Kotlin coroutine, inline or generated Expo/React Native methods. Preserve `jadx.log`; use AAPT, APKTool, DEX inventory and other independent evidence. Do not interpret the error count as a vulnerability count.

## APK has no `assets/` directory or JS bundle

Some React Native debug builds load JavaScript from a Metro development server. This is a hypothesis until confirmed from manifest metadata, application logs, source configuration or controlled runtime testing.

## ADB shows no devices

`adb devices -l` listing no devices means no ADB target is currently connected/authorized. PRoot alone does not create an emulator or Android device connection.

## Android tools missing

Package names and availability differ across Debian releases and architectures. Install Android SDK Build Tools and JADX only from trusted sources; verify release checksums/signatures where provided.

## PRoot limitations

Debian PRoot is not a VM and cannot provide kernel features, hardware virtualization, cgroups or all Android device interfaces. Some tools may run with reduced functionality.
