#!/bin/bash

PWDSRC=`dirname "$(readlink -f "$0")"`
${PWDSRC}/apt-install.sh

mkdir -p ~/ffmpeg_sources

cd ~/ffmpeg_sources && \
git clone https://github.com/gravity-addiction/jetson-nano-scripts

### Redis Server
# user, folder, config setup
sudo adduser --system --group --no-create-home redis && \
sudo mkdir -p /var/lib/redis && sudo chmod 770 /var/lib/redis && \
sudo mkdir -p /etc/redis && sudo chown redis:redis /etc/redis && \
sudo mkdir -p /run/redis && sudo chown root:redis /run/redis && sudo chmod g+s /run/redis && \
sudo mkdir -p /var/log/redis && sudo chown redis:adm /var/log/redis && sudo chmod 775 /var/log/redis && sudo chmod g+s /var/log/redis && \
sudo cp jetson-nano-scripts/redis/redis.conf /etc/redis/redis.conf && \
sudo cp jetson-nano-scripts/redis/redis.service /etc/systemd/system/redis.service && \
sudo chown -R redis:redis /etc/redis/redis.conf && sudo chmod 640 /etc/redis/redis.conf && \
cd ~/ffmpeg_sources && \
wget https://download.redis.io/releases/redis-6.2.5.tar.gz && \
tar zxf redis-6.2.5.tar.gz && \
cd redis-6.2.5 && \
make -j4 && \
sudo make install && \
sudo systemctl daemon-reload && \
sudo systemctl restart redis && \
sudo systemctl enable redis