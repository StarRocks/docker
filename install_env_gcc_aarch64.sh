#!/bin/bash
yum install centos-release-scl -y
yum install devtoolset-10 -y
ln -sf /opt/rh/devtoolset-10/root/bin/* /usr/bin/


yum install -y epel-release
yum install -y ccache python3
yum install -y bzip2 wget git libstdc++-static byacc flex automake libtool binutils-devel bison ncurses-devel make mlocate unzip patch which vim-common redhat-lsb-core zip libcurl-devel updatedb