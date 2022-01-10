FROM docker.io/library/centos:centos7.9.2009

ENV DEFAULT_DIR /var/local

RUN yum install -y epel-release 

# CCACHE
RUN yum install -y ccache

# GCC
RUN yum install centos-release-scl -y
RUN yum install devtoolset-10 -y
RUN echo "source /opt/rh/devtoolset-10/enable" >> /etc/bashrc

# CMAKE
RUN yum install cmake3 -y
RUN ln -s /usr/bin/cmake3 /usr/bin/cmake

# JDK
RUN yum install java-1.8.0-openjdk -y
RUN echo "export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")" >> /etc/bashrc

# MAVEN
RUN yum install maven -y

# dependencies
RUN yum install -y bzip2 wget git libstdc++-static byacc flex automake libtool binutils-devel bison ncurses-devel make mlocate unzip patch which vim-common redhat-lsb-core zip libcurl-devel\
  && updatedb \
  && yum -y clean all

# build environment
WORKDIR ${DEFAULT_DIR}

COPY thirdparty ${DEFAULT_DIR}/thirdparty 

# env
ENV STARROCKS_THIRDPARTY /var/local/thirdparty

WORKDIR ${DEFAULT_DIR}

CMD top