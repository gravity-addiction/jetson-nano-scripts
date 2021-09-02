#!/bin/bash

PWDSRC=`dirname "$(readlink -f "$0")"`
${PWDSRC}/apt-install.sh

sudo apt-get install -y git nginx-light libnginx-mod-rtmp

mkdir -p ~/ffmpeg_sources

cd ~/ffmpeg_sources && \
git clone https://github.com/gravity-addiction/jetson-nano-scripts

### Nginx Config
# RTMP / HLS Streaming configs by:
# https://www.ustoopia.nl/featured/create-a-secure-adaptive-bit-rate-hls-stream-with-nginx-rtmp-ffmpeg-on-ubuntu-20-04-2021/
cd ~/ffmpeg_sources && \
git clone https://github.com/arut/nginx-rtmp-module && \
sudo mkdir -p /var/www/web && \
sudo mkdir -p /var/livestream/hls /var/livestream/dash /var/livestream/recordings /var/livestream/keys && \
sudo ln -s /var/livestream/hls /var/www/web/hls && \
sudo ln -s /var/livestream/dash /var/www/web/dash && \
sudo cp nginx-rtmp-module/stat.xsl /var/www/web/stat.xsl && \
sudo cp jetson-nano-scripts/nginx/crossdomain.xml /var/www/html/ && \
sudo cp jetson-nano-scripts/nginx/crossdomain.xml /var/www/web/ && \
sudo cp -R jetson-nano-scripts/nginx/rtmp.d/* /etc/nginx/rtmp.d/ && \
sudo cp /var/www/html/index.nginx-debian.html /var/www/web/index.html && \
sudo chown -R www-data:www-data /var/livestream /var/www/web /var/www/html && \
sudo mkdir -p /etc/nginx/rtmp.d && \
sudo cp jetson-nano-scripts/nginx/default.conf /etc/nginx/sites-available/ && \
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx-original.conf && \
sudo cp jetson-nano-scripts/nginx/nginx.conf /etc/nginx/ && \
cd /etc/nginx/sites-enabled && \
sudo ln -s ../sites-available/default.conf default.conf && \
sudo nginx -t && \
sudo nginx systemctl restart nginx.service

