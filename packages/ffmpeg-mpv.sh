#!/bin/bash

if [ -f ./apt-install.sh ]; then
./apt-install.sh
fi

mkdir -p ~/Downloads

###
# Most of this script comes from
# https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

## NASM Installer
if [ ! -e ~/Downloads/nasm-2.15.05 ]; then
cd ~/Downloads && \
wget https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.bz2 && \
tar xjvf nasm-2.15.05.tar.bz2 && \
cd nasm-2.15.05 && \
./autogen.sh && \
./configure && \
make -j4 && \
sudo make install
fi

## h264 Install
if [ ! -e ~/Downloads/x264 ]; then
cd ~/Downloads && \
git -C x264 pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/x264.git && \
cd x264 && \
./configure --enable-static --enable-pic && \
make -j4 && \
sudo make install
fi

## h265 Install
if [ ! -e ~/Downloads/x265_git ]; then
cd ~/Downloads && \
git -C x265_git pull 2> /dev/null || git clone https://bitbucket.org/multicoreware/x265_git && \
cd x265_git/build/linux && \
cmake -G "Unix Makefiles" ../../source && \
make -j4 && \
sudo make install
fi

## libvpx Install
if [ ! -e ~/Downloads/libvpx ]; then
cd ~/Downloads && \
git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
cd libvpx && \
./configure --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm && \
make -j4 && \
sudo make install
fi

## libfdk-aac Install
if [ ! -e ~/Downloads/fdk-aac ]; then
cd ~/Downloads && \
git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
cd fdk-aac && \
autoreconf -fiv && \
./configure && \
make -j4 && \
sudo make install
fi

## libmp3lame Install
if [ ! -e ~/Downloads/lame-3.100 ]; then
cd ~/Downloads && \
wget -O lame-3.100.tar.gz https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz && \
tar xzvf lame-3.100.tar.gz && \
cd lame-3.100 && \
./configure --enable-nasm && \
make -j4 && \
sudo make install
fi

## libopus Install
if [ ! -e ~/Downloads/opus ]; then
cd ~/Downloads && \
git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
cd opus && \
./autogen.sh && \
./configure && \
make && \
sudo make install
fi

## libaom Install
if [ ! -e ~/Downloads/aom_build ]; then
cd ~/Downloads && \
git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom && \
mkdir -p aom_build && \
cd aom_build && \
cmake -G "Unix Makefiles" -DENABLE_NASM=on ../aom && \
make && \
sudo make install

## libsvtav1 Install
if [ ! -e ~/Downloads/libvpx ]; then
cd ~/Downloads && \
git -C SVT-AV1 pull 2> /dev/null || git clone https://gitlab.com/AOMediaCodec/SVT-AV1.git && \
mkdir -p SVT-AV1/build && \
cd SVT-AV1/build && \
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release .. && \
make && \
sudo make install
fi

## libdav1d Install
if [ ! -e ~/Downloads/dav1d ]; then
sudo -H pip3 install meson
cd ~/Downloads && \
git -C dav1d pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/dav1d.git && \
mkdir -p dav1d/build && \
cd dav1d/build && \
meson setup -Denable_tools=false -Denable_tests=false --default-library=static .. && \
ninja && \
sudo ninja install
fi

## libvmaf Install
if [ ! -e ~/Downloads/vmaf-2.1.1 ]; then
cd ~/Downloads && \
wget https://github.com/Netflix/vmaf/archive/v2.1.1.tar.gz && \
tar xvf v2.1.1.tar.gz && \
mkdir -p vmaf-2.1.1/libvmaf/build && \
cd vmaf-2.1.1/libvmaf/build && \
meson setup -Denable_tests=false -Denable_docs=false --buildtype=release --default-library=static .. && \
ninja && \
sudo ninja install
fi

## nv-codec Install
if [ ! -e ~/Downloads/nv-codec-headers ]; then
# CUDA support by nVidia Forums User: tommyfeelgood - https://forums.developer.nvidia.com/t/ffmpeg-using-hardware-gpu-cuda/72312/22
cd ~/Downloads && \
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git && \
cd nv-codec-headers && \
make -j4 && sudo make install && sudo ldconfig
fi

## jocover Installer
if [ ! -e ~/Downloads/jetson-ffmpeg ]; then
# NVMPI Support by https://github.com/jocover/jetson-ffmpeg
cd ~/Downloads && \
git clone https://github.com/jocover/jetson-ffmpeg.git && \
cd jetson-ffmpeg && \
mkdir build && \
cd build && \
cmake .. && \
make && sudo make install && sudo ldconfig
fi

## FFmpeg Install
if [ ! -e ~/Downloads/ffmpeg ]; then
# NVMPI Support by https://github.com/jocover/jetson-ffmpeg
# CUDA support by nVidia Forums User: tommyfeelgood - https://forums.developer.nvidia.com/t/ffmpeg-using-hardware-gpu-cuda/72312/22
cd ~/Downloads && \
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
fi

## MPV Install
# https://github.com/mpv-player/mpv/#compilation
# with config switches from tommyfeelgood
if [ ! -e ~/Downloads/mpv ]; then
cd ~/Downloads && \
git clone https://github.com/mpv-player/mpv.git --depth 1 && \
cd mpv && \
./bootstrap.py && \
./waf configure --enable-libmpv-shared --enable-sdl2 --enable-ffmpeg-strict-abi --enable-xv && \
sudo ./waf install
fi
