#!/bin/bash

# Get full path to this folder
PWDSRC=`dirname "$(readlink -f "$0")"`

# Add & Generate en_US.UTF to system locales
sudo sed -i '/en_US.UTF/s/^# //' /etc/locale.gen && \
sudo locale-gen

# Update everything to latest
sudo apt update && \
sudo apt dist-upgrade -y

cd "${PWDSRC}" && \
./installers/apt-install.sh && \
cd "${PWDSRC}" && \
./installers/ffmpeg-mpv.sh && \
cd "${PWDSRC}" && \
./installers/redis.sh && \
cd "${PWDSRC}" && \
./installers/nginx.sh && \
echo && \
echo "Installer Completed!"
