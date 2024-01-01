#!/bin/env bash
set -Eeuxo pipefail
sudo usermod -U root
echo "PermitRootLogin yes" | sudo tee /etc/ssh/sshd_config.d/PermitRootLogin.conf
sudo service sshd restart
