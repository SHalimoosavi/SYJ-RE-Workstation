#!/usr/bin/env bash
set -Eeuo pipefail
pkg update
pkg install -y git proot-distro
echo
echo "Termux base packages installed."
echo "Next: proot-distro install debian"
echo "Optional: termux-setup-storage (only if you need Android shared storage)."
