#!/bin/env bash
set -Eeuxo pipefail
echo "net.ipv4.conf.all.forwarding=1" | sudo tee /etc/sysctl.d/10-forwarding.conf
sudo sysctl -p
