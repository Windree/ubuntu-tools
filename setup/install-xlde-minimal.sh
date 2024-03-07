#!/usr/bin/env bash
set -Eeuxo pipefail
sudo apt update -y
sudo apt install -y xorg
sudo apt install -y --no-install-recommends lightdm-gtk-greeter
sudo apt install -y --no-install-recommends lightdm
sudo apt install -y --no-install-recommends lxde-icon-theme
sudo apt install -y --no-install-recommends lxde-core
sudo apt install -y --no-install-recommends lxde-common
sudo apt install -y --no-install-recommends policykit-1 lxpolkit
sudo apt install -y --no-install-recommends lxsession-logout
sudo apt install -y --no-install-recommends gvfs-backends
