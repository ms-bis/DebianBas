#!/bin/bash
# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# runs mirror selection script
git clone https://github.com/IceM4nn/mirrorscript-v2.git
python mirrorscript-v2/mirrorscript-v2.py # mirror

# Update packages list and update system
apt update
apt upgrade -y

# Install nala
apt install nala -y

# change shell
chsh -s /usr/bin/bash

echo "after reboot, run di.sh" 2>&1

## reboot
reboot
