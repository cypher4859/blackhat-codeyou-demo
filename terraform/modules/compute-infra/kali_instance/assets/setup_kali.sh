#!/bin/bash

apt update
# apt full-upgrade -y
echo "[i] Installing Xfce4 & xrdp (this will take a while as well)"
apt-get install -y kali-desktop-xfce xorg xrdp

echo "[i] Configuring xrdp to listen to port 3390 (but not starting the service)"
sed -i 's/port=3389/port=3390/g' /etc/xrdp/xrdp.ini

wget https://gitlab.com/kalilinux/recipes/kali-scripts/-/raw/main/xfce4.sh
chmod +x xfce4.sh
./xfce4.sh

# In the case of AWS
echo kali:kali | chpasswd