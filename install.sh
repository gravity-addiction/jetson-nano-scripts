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
./packages/apt-install.sh && \
cd "${PWDSRC}" && \
./packages/ffmpeg-mpv.sh && \
cd "${PWDSRC}" && \
./packages/redis.sh && \
cd "${PWDSRC}" && \
./packages/nginx.sh && \
echo && \
echo "Installer Completed!"
