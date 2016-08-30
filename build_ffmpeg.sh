#!/bin/bash

jval=`nproc`
FFHOME=`pwd`

mkdir -p $FFHOME/ffmpeg_sources && \
mkdir -p $FFHOME/ffmpeg_build && \
mkdir -p $FFHOME/ffmpeg_bin && \
\
\
apt update && \
apt install wget curl tar git mercurial tree vim -y && \
apt install autoconf automake build-essential \
            libass-dev libfreetype6-dev libsdl1.2-dev \
            libtheora-dev libtool libva-dev libvdpau-dev \
            libvorbis-dev libxcb1-dev libxcb-shm0-dev \
            libxcb-xfixes0-dev pkg-config texinfo \
            zlib1g-dev cmake-curses-gui -y && \
apt install yasm libx264-dev libmp3lame-dev \
            libopus-dev libxv-dev \
            libxvmc-dev libxvidcore-dev -y && \
\
\
cd $FFHOME/ffmpeg_sources && \
wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master && \
tar xzf fdk-aac.tar.gz && \
cd $FFHOME/ffmpeg_sources/mstorsjo-fdk-aac* && \
autoreconf -fiv && \
./configure --prefix="$HOME/ffmpeg_build" \
            --disable-shared && \
make -j$jval && \
make install && \
\
\
cd $FFHOME/ffmpeg_sources && \
hg clone https://bitbucket.org/multicoreware/x265 && \
cd $FFHOME/ffmpeg_sources/x265/build/linux && \
cmake -G "Unix Makefiles" \
      -DCMAKE_INSTALL_PREFIX="$FFHOME/ffmpeg_build" \
      -DENABLE_SHARED:bool=off ../../source && \
make -j$jval && \
make install && \
\
\
cd $FFHOME/ffmpeg_sources && \
wget http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.5.0.tar.bz2 && \
tar xjf libvpx-1.5.0.tar.bz2 && \
cd $FFHOME/ffmpeg_sources/libvpx-1.5.0 && \
./configure --prefix="$FFHOME/ffmpeg_build" \
            --disable-examples \
            --disable-unit-tests \
            --disable-shared && \
make -j$jval && \
make install && \
\
\
cd $FFHOME/ffmpeg_sources && \
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
tar xjf ffmpeg-snapshot.tar.bz2 && \
cd $FFHOME/ffmpeg_sources/ffmpeg && \
export PKG_CONFIG_PATH=$FFHOME/ffmpeg_build/lib/pkgconfig:$PKG_CONFIG_PATH && \
./configure \
  --prefix="$FFHOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$FFHOME/ffmpeg_build/include" \
  --extra-ldflags="-L$FFHOME/ffmpeg_build/lib" \
  --bindir="$FFHOME/ffmpeg_bin" \
  --enable-gpl \
  --enable-version3 \
  --enable-nonfree \
  --enable-avisynth \
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
  --enable-libxvid && \
make -j$jval && \
make install && \
\
\
mv $FFHOME/ffmpeg_bin/* $FFHOME && \
rm -rf $FFHOME/ffmpeg_* && \
\
\
echo "done!"
