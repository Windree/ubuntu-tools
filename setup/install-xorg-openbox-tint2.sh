#!/usr/bin/env sh
echo "Instaling packages..." && \
sudo apt install xrdp tint2 openbox obconf fonts-dejavu fonts-liberation fonts-ubuntu fonts-font-awesome fonts-firacode && \
echo "Creating config folder..." && \
mkdir -p ~/.config/openbox && \
echo "Copying default config..." && \
cp /etc/xdg/openbox/* ~/.config/openbox/ && \
echo "Adding tint2 to autostart if not exists..." && \
grep -qxF 'tint2 &' ~/.config/openbox/autostart || echo 'tint2 &' >> ~/.config/openbox/autostart
