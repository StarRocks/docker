#!/bin/bash
yum install -y bzip2 wget git gcc-c++ libstdc++-static byacc flex automake libtool binutils-devel bison ncurses-devel make mlocate unzip patch which vim-common redhat-lsb-core zip libcurl-devel updatedb 
yum -y clean all
rm -rf /var/cache/yum
mkdir -p  /var/local/gcc
curl -fsSL -o /tmp/gcc.tar.gz  $1/gcc-$2.tar.gz 
tar -xzf /tmp/gcc.tar.gz -C /var/local/gcc --strip-components=1 
cd /var/local/gcc 
sed -i 's/ftp:\/\/gcc.gnu.org\/pub\/gcc\/infrastructure\//http:\/\/mirror.linux-ia64.org\/gnu\/gcc\/infrastructure\//g' contrib/download_prerequisites 
./contrib/download_prerequisites 
./configure --disable-multilib --enable-languages=c,c++ --prefix=/usr 
make -j$[$(nproc)/4+1] && make install 
rm -rf /var/local/gcc 
rm -f /tmp/gcc.tar.gz