#!/usr/bin/env bash
set -Eeuxo pipefail
cat <<EOF | sudo tee /etc/systemd/system/vmware-modules-rebuild.service
[Unit]
Description=Recompiles vmware modules
Requires=vmware.service
Before=vmware.service
ConditionPathExists=!/dev/vmmon
 
[Service]
Type=oneshot
ExecStart=/usr/bin/vmware-modconfig --console --install-all
 
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable vmware-modules-rebuild
