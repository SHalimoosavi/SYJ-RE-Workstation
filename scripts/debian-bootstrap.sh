#!/usr/bin/env bash
set -Eeuo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Run inside Debian PRoot as root, or use sudo." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y \
  bash ca-certificates curl wget git python3 python3-venv \
  file unzip zip p7zip-full binutils gdb sqlite3 yara \
  default-jre-headless adb tshark

echo
echo "Base Debian packages installed."
echo "Optional Android tools (aapt, apksigner, apktool, jadx) may require separate trusted installation."
for tool in aapt apksigner apktool jadx; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf '[OK] %s\n' "$tool"
  else
    printf '[OPTIONAL MISSING] %s\n' "$tool"
  fi
done
