#!/bin/bash
# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Enables snap
sudo nala update && sudo nala install snapd -y --install-suggests
sudo snap install core
## Enables snapd
sudo systemctl enable snapd.service
sudo systemctl start snapd.service
sudo systemctl enable snapd.apparmor.service
sudo systemctl start snapd.apparmor.service
sudo systemctl enable apparmor.service
sudo systemctl start apparmor.service
## Configure
sudo apparmor_parser -r /etc/apparmor.d/*snap-confine*
sudo apparmor_parser -r /var/lib/snapd/apparmor/profiles/snap-confine*
service snapd.apparmor start

# Enables flatpak
sudo nala update && sudo nala install flatpak -y --install-suggests
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "after reboot, run tri.sh" 2>&1

## reboot
reboot


