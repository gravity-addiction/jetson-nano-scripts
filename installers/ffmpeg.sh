#!/bin/bash

PWDSRC=`dirname "$(readlink -f "$0")"`
${PWDSRC}/apt-install.sh

mkdir -p ~/ffmpeg_sources

###
# Most of this script comes from
# https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

## NASM Installer
cd ~/ffmpeg_sources && \
wget https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.bz2 && \
tar xjvf nasm-2.15.05.tar.bz2 && \
cd nasm-2.15.05 && \
./autogen.sh && \
./configure && \
make -j4 && \
sudo make install

## h264 Install
cd ~/ffmpeg_sources && \
git -C x264 pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/x264.git && \
cd x264 && \
./configure --enable-static --enable-pic && \
make -j4 && \
sudo make install

## h265 Install
cd ~/ffmpeg_sources && \
git -C x265_git pull 2> /dev/null || git clone https://bitbucket.org/multicoreware/x265_git && \
cd x265_git/build/linux && \
cmake -G "Unix Makefiles" ../../source && \
make -j4 && \
sudo make install

## libvpx Install
cd ~/ffmpeg_sources && \
git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
cd libvpx && \
./configure --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm && \
make -j4 && \
sudo make install

## libfdk-aac Install
cd ~/ffmpeg_sources && \
git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
cd fdk-aac && \
autoreconf -fiv && \
./configure && \
make -j4 && \
sudo make install

## libmp3lame Install
cd ~/ffmpeg_sources && \
wget -O lame-3.100.tar.gz https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz && \
tar xzvf lame-3.100.tar.gz && \
cd lame-3.100 && \
./configure --enable-nasm && \
make -j4 && \
sudo make install

## libopus Install
cd ~/ffmpeg_sources && \
git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
cd opus && \
./autogen.sh && \
./configure && \
make && \
sudo make install

## libaom Install
cd ~/ffmpeg_sources && \
git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom && \
mkdir -p aom_build && \
cd aom_build && \
cmake -G "Unix Makefiles" -DENABLE_NASM=on ../aom && \
make && \
sudo make install

## libsvtav1 Install
cd ~/ffmpeg_sources && \
git -C SVT-AV1 pull 2> /dev/null || git clone https://gitlab.com/AOMediaCodec/SVT-AV1.git && \
mkdir -p SVT-AV1/build && \
cd SVT-AV1/build && \
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release .. && \
make && \
sudo make install

## libdav1d Install
sudo -H pip3 install meson
cd ~/ffmpeg_sources && \
git -C dav1d pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/dav1d.git && \
mkdir -p dav1d/build && \
cd dav1d/build && \
meson setup -Denable_tools=false -Denable_tests=false --default-library=static .. && \
ninja && \
sudo ninja install

## libvmaf Install
cd ~/ffmpeg_sources && \
wget https://github.com/Netflix/vmaf/archive/v2.1.1.tar.gz && \
tar xvf v2.1.1.tar.gz && \
mkdir -p vmaf-2.1.1/libvmaf/build && \
cd vmaf-2.1.1/libvmaf/build && \
meson setup -Denable_tests=false -Denable_docs=false --buildtype=release --default-library=static .. && \
ninja && \
sudo ninja install

## nv-codec Install
# CUDA support by nVidia Forums User: tommyfeelgood - https://forums.developer.nvidia.com/t/ffmpeg-using-hardware-gpu-cuda/72312/22
cd ~/ffmpeg_sources && \
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && \
cd nv-codec-headers && \
make -j4 && sudo make install && sudo ldconfig

## jocover Installer
# NVMPI Support by https://github.com/jocover/jetson-ffmpeg
cd ~/ffmpeg_sources && \
git clone https://github.com/jocover/jetson-ffmpeg.git && \
cd jetson-ffmpeg && \
mkdir build && \
cd build && \
cmake .. && \
make && sudo make install && sudo ldconfig

## FFmpeg Install
# NVMPI Support by https://github.com/jocover/jetson-ffmpeg
# CUDA support by nVidia Forums User: tommyfeelgood - https://forums.developer.nvidia.com/t/ffmpeg-using-hardware-gpu-cuda/72312/22
cd ~/ffmpeg_sources && \
git clone git://source.ffmpeg.org/ffmpeg.git -b release/4.4 --depth=1 && \
wget -O ffmpeg/ffmpeg_nvmpi-n44.patch https://raw.githubusercontent.com/gravity-addiction/sdobox/master/build-scripts/jetson-nano/ffmpeg_nvmpi-n44.patch && \
wget -O ffmpeg/libavcodec/nvmpi_enc.c https://raw.githubusercontent.com/gravity-addiction/sdobox/master/build-scripts/jetson-nano/nvmpi_enc.c && \
wget -O ffmpeg/libavcodec/nvmpi_dec.c https://raw.githubusercontent.com/gravity-addiction/sdobox/master/build-scripts/jetson-nano/nvmpi_dec.c && \
cd ffmpeg && \
git apply ffmpeg_nvmpi-n44.patch && \
./configure \
  --pkg-config-flags="--static" \
  --extra-cflags="-I/usr/local/cuda/include" \
  --extra-ldflags="-L/usr/local/cuda/lib64" \
  --extra-libs="-lpthread -lm" \
  --ld="g++" \
  --enable-gpl \
  --enable-gnutls \
  --enable-libaom \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libsvtav1 \
  --enable-libdav1d \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree \
  --enable-nvmpi \
  --enable-shared \
  --enable-cuda \
  --enable-cuvid \
  --enable-nvenc \
  --enable-libnpp && \
make -j4 && \
sudo make install

## MPV Install
# https://github.com/mpv-player/mpv/#compilation
# with config switches from tommyfeelgood
cd ~/ffmpeg_sources && \
git clone https://github.com/mpv-player/mpv.git --depth 1 && \
cd mpv && \
./bootstrap.py && \
./waf configure --enable-libmpv-shared --enable-sdl2 --enable-ffmpeg-strict-abi --enable-xv && \
sudo ./waf install
