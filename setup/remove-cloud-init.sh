#!/bin/env bash
set -Eeuxo pipefail
sudo apt install -y netplan.io
sudo apt purge -y --autoremove cloud-init