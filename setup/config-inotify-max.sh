#!/bin/env bash
set -Eeuxo pipefail
echo "fs.inotify.max_user_watches=524288" | sudo tee /etc/sysctl.d/10-fs-inotify-max_user_watches.conf
sudo sysctl -p
