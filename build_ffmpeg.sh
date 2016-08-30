#!/bin/bash

jval=`nproc`

mkdir -p $HOME/ffmpeg_sources && \
mkdir -p $HOME/ffmpeg_build && \
mkdir -p $HOME/ffmpeg_bin && \
\
\
apt update && \
apt install wget curl tar git mercurial -y && \
apt install autoconf automake build-essential \
            libass-dev libfreetype6-dev libsdl1.2-dev \
            libtheora-dev libtool libva-dev libvdpau-dev \
            libvorbis-dev libxcb1-dev libxcb-shm0-dev \
            libxcb-xfixes0-dev pkg-config texinfo \
            zlib1g-dev cmake-curses-gui -y && \
apt install yasm libx264-dev libfdk-aac-dev \
            libmp3lame-dev libopus-dev libxv-dev \
            libxvmc-dev libxvidcore-dev -y && \
\
\
cd $HOME/ffmpeg_sources && \
hg clone https://bitbucket.org/multicoreware/x265 && \
cd $HOME/ffmpeg_sources/x265/build/linux && \
cmake -G "Unix Makefiles" \
      -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" \
      -DENABLE_SHARED:bool=off ../../source && \
make -j$jval && \
make install && \
\
\
cd $HOME/ffmpeg_sources && \
wget http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.5.0.tar.bz2 && \
tar xjf libvpx-1.5.0.tar.bz2 && \
cd $HOME/ffmpeg_sources/libvpx-1.5.0 && \
./configure --prefix="$HOME/ffmpeg_build" \
            --disable-examples \
            --disable-unit-tests \
            --disable-shared && \
make -j$jval && \
make install && \
\
\
cd $HOME/ffmpeg_sources && \
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
tar xjf ffmpeg-snapshot.tar.bz2 && \
cd $HOME/ffmpeg_sources/ffmpeg && \
export PKG_CONFIG_PATH=$HOME/ffmpeg_build/lib/pkgconfig:$PKG_CONFIG_PATH && \
./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --bindir="$HOME/ffmpeg_bin" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libxvid \
  --enable-avisynth \
  --enable-version3 \
  --enable-nonfree && \
make -j$jval && \
make install && \
\
\
mv $HOME/ffmpeg_bin/* $HOME && \
rm -rf $HOME/ffmpeg_* && \
\
\
echo "done!"
