#!/bin/bash

if [ -f ./apt-install.sh ]; then
./apt-install.sh
fi

mkdir -p ~/Downloads

if [ ! -e ~/Downloads/jetson-nano-scripts ]; then
cd ~/Downloads && \
git clone https://github.com/gravity-addiction/jetson-nano-scripts

### Redis Server
# user, folder, config setup
sudo adduser --system --group --no-create-home redis

if [ ! -e /var/lib/redis ]; then
sudo mkdir -p /var/lib/redis && \
sudo chmod 770 /var/lib/redis
fi

if [ ! -e /etc/redis ]; then
sudo mkdir -p /etc/redis && \
sudo chown redis:redis /etc/redis
fi

if [ ! -e /run/redis ]; then
sudo mkdir -p /run/redis && \
sudo chown root:redis /run/redis && \
sudo chmod g+s /run/redis
fi

if [ ! -e /var/log/redis ]; then
sudo mkdir -p /var/log/redis && \
sudo chown redis:adm /var/log/redis && \
sudo chmod 775 /var/log/redis && \
sudo chmod g+s /var/log/redis
fi

if [ ! -e /etc/redis/redis.conf ]; then
sudo cp -n jetson-nano-scripts/redis/redis.conf /etc/redis/redis.conf && \
sudo chown -R redis:redis /etc/redis/redis.conf && \
sudo chmod 640 /etc/redis/redis.conf
fi

sudo cp -n jetson-nano-scripts/redis/redis.service /etc/systemd/system/redis.service

if [ ! -e ~/Downloads/redis-6.2.5 ]; then
cd ~/Downloads && \
wget https://download.redis.io/releases/redis-6.2.5.tar.gz && \
tar zxf redis-6.2.5.tar.gz && \
cd redis-6.2.5 && \
make -j4 && \
sudo make install && \
sudo systemctl daemon-reload && \
sudo systemctl restart redis && \
sudo systemctl enable redis
fi
