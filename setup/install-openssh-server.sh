#!/bin/env bash
set -Eeuxo pipefail
sudo apt update -y
sudo apt install -y openssh-server
sudo ufw allow 22/tcp
sudo ufw reload
