#!/bin/env bash
set -Eeuo pipefail
function main() {
  if ! sudo apt update 2> /dev/null > /dev/null; then
    echo "Faled to fetch updates"
    return
  fi
  local updates_count=$(/usr/lib/update-notifier/apt-check 2>&1 | cut -d ';' -f1)
  local security_updates_count=$(/usr/lib/update-notifier/apt-check 2>&1 | cut -d ';' -f2)
  echo "Updates/Security: $updates_count/$security_updates_count"
  if ((security_updates_count == 0)); then
    exit 0
  fi
  export NEEDRESTART_MODE=a
  sudo apt upgrade -y 2> /dev/null && sudo apt autoremove -y  2> /dev/null && sudo reboot
}

main
