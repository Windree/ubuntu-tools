#!/bin/env bash
set -Eeuxo pipefail
cat <<EOF | sudo tee /etc/systemd/system/vmware-autostop.service
[Unit]
Description=Stops VMware guests
Requires=vmware.service
Before=shutdown.target
 
[Service]
Type=oneshot
ExecStart=/usr/bin/vmrun list | /usr/bin/tail -n +2 | /usr/bin/xargs -I {} /usr/bin/vmrun stop {} nogui
 
[Install]
WantedBy=halt.target reboot.target shutdown.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable vmware-autostop
