#!/bin/bash

if [ -f ./apt-install.sh ]; then
./apt-install.sh
fi

sudo apt-get install -y git nginx-light libnginx-mod-rtmp

mkdir -p ~/Downloads

if [ ! -e ~/Downloads/jetson-nano-scripts ]; then
cd ~/Downloads && \
git clone https://github.com/gravity-addiction/jetson-nano-scripts
fi

### Nginx Config
# RTMP / HLS Streaming configs by:
# https://www.ustoopia.nl/featured/create-a-secure-adaptive-bit-rate-hls-stream-with-nginx-rtmp-ffmpeg-on-ubuntu-20-04-2021/
if [ ! -e ~/Downloads/nginx-rtmp-module ]; then
cd ~/Downloads && \
git clone https://github.com/arut/nginx-rtmp-module
fi

sudo mkdir -p /var/www/web
sudo mkdir -p /var/livestream/hls /var/livestream/dash /var/livestream/recordings /var/livestream/keys

if [ ! -e /var/www/web/hls ]; then
sudo ln -s /var/livestream/hls /var/www/web/
fi

if [ ! -e /var/www/web/dash ]; then
sudo ln -s /var/livestream/dash /var/www/web/
fi

cd ~/Downloads && \
sudo cp -n nginx-rtmp-module/stat.xsl /var/www/web/stat.xsl && \
sudo cp -n jetson-nano-scripts/nginx/crossdomain.xml /var/www/html/ && \
sudo cp -n jetson-nano-scripts/nginx/crossdomain.xml /var/www/web/ && \
sudo cp -R -n jetson-nano-scripts/nginx/rtmp.d/* /etc/nginx/rtmp.d/ && \
sudo cp -n /var/www/html/index.nginx-debian.html /var/www/web/index.html && \
sudo chown www-data:www-data /var/livestream/hls /var/livestream/dash /var/livestream/recordings /var/livestream/keys /var/www/web /var/www/html && \
sudo mkdir -p /etc/nginx/rtmp.d && \
sudo mv -n /etc/nginx/nginx.conf /etc/nginx/nginx-original.conf && \
sudo cp -n jetson-nano-scripts/nginx/nginx.conf /etc/nginx/

if [ ! -e /etc/nginx/sites-available/default.conf ]; then
cd ~/Downloads && \
sudo cp -n jetson-nano-scripts/nginx/default.conf /etc/nginx/sites-available/default.conf

if [ ! -e /etc/nginx/sites-enabled/default.conf ]; then
cd /etc/nginx/sites-enabled && \
sudo ln -s ../sites-available/default.conf default.conf
fi

sudo nginx -t && \
sudo systemctl restart nginx.service
fi

