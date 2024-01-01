#!/bin/env bash
set -Eeuxo pipefail
apt install -y tightvncserver xfce4 xorg gnome-icon-theme dbus-x11 --no-install-recommends
apt install -y pavucontrol

vncserver :0
vncserver -kill :0

user=$(whoami)
cat <<EOF | sudo tee /etc/systemd/system/vncserver@.service
[Unit]
Description=Start TightVNC server at startup
After=syslog.target network.target
[Service]
Type=forking
User=$user
Group=$user
WorkingDirectory=$HOME
PIDFile=$HOME/.vnc/%H:%i.pid
ExecStartPre=-/bin/sh -c "/usr/bin/vncserver -kill :%i > /dev/null 2>&1"
ExecStart=/usr/bin/vncserver -depth 24 -geometry 1920x1200 :%i
ExecStop=/usr/bin/vncserver -kill :%i
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable vncserver@0.service

sudo systemctl start vncserver@0
