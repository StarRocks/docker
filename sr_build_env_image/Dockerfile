FROM centos:centos7.5.1804
ARG JDK_SOURCE
ENV DEFAULT_DIR /var/local

ARG GCC_VERSION=10.3.0
ARG GCC_URL=https://mirrors.ustc.edu.cn/gnu/gcc/gcc-${GCC_VERSION}

# install dependencies and build gcc
RUN yum install -y bzip2 wget git gcc-c++ libstdc++-static byacc flex automake libtool binutils-devel bison ncurses-devel make mlocate unzip patch which vim-common redhat-lsb-core zip libcurl-devel \
  && updatedb \
  && yum -y clean all \
  && rm -rf /var/cache/yum \
  && mkdir -p  /var/local/gcc \
  && curl -fsSL -o /tmp/gcc.tar.gz  ${GCC_URL}/gcc-${GCC_VERSION}.tar.gz \
  && tar -xzf /tmp/gcc.tar.gz -C /var/local/gcc --strip-components=1 \
  && cd /var/local/gcc \
  && sed -i 's/ftp:\/\/gcc.gnu.org\/pub\/gcc\/infrastructure\//http:\/\/mirror.linux-ia64.org\/gnu\/gcc\/infrastructure\//g' contrib/download_prerequisites \
  && ./contrib/download_prerequisites \
  && ./configure --disable-multilib --enable-languages=c,c++ --prefix=/usr \
  && make -j$[$(nproc)/4+1] && make install \
  && rm -rf /var/local/gcc \
  && rm -f /tmp/gcc.tar.gz


# build cmake
ARG CMAKE_VERSION=3.16.3
ARG CMAKE_DOWNLOAD_URL=https://cmake.org/files/v3.16/cmake-${CMAKE_VERSION}.tar.gz
RUN mkdir -p /tmp/cmake && curl -fsSL -o /tmp/cmake.tar.gz ${CMAKE_DOWNLOAD_URL} \
    && tar -zxf /tmp/cmake.tar.gz -C /tmp/cmake --strip-components=1 \
    && cd /tmp/cmake \
    && ./bootstrap --system-curl \
    && gmake -j$[$(nproc)/4+1] \
    && gmake install \
    && rm -rf /tmp/cmake.tar.gz \
    && rm -rf /tmp/cmake

# install jdk
COPY ./jdk.rpm ./
RUN touch  ${DEFAULT_DIR}/install_jdk.sh \
    && echo '#!/bin/bash' >> ${DEFAULT_DIR}/install_jdk.sh \
    && echo 'rpm -Uvh jdk.rpm > /dev/null 2>&1' >>  ${DEFAULT_DIR}/install_jdk.sh \
    && echo 'mv /usr/java/jdk* /usr/java/jdk' >>  ${DEFAULT_DIR}/install_jdk.sh \
    && echo 'export JAVA_HOME=/usr/java/jdk' >>  ${DEFAULT_DIR}/install_jdk.sh \
    && echo 'echo "export JAVA_HOME=/usr/java/jdk" >> /etc/environment' >>  ${DEFAULT_DIR}/install_jdk.sh \
    && echo 'export JRE_HOME=/usr/java/jdk/jre' >>  ${DEFAULT_DIR}/install_jdk.sh \
    && echo 'echo "export JRE_HOME=/usr/java/jdk/jre" >> /etc/environment' >>  ${DEFAULT_DIR}/install_jdk.sh \
    && echo 'ls /usr/java/jdk > /dev/null 2>&1' >>  ${DEFAULT_DIR}/install_jdk.sh \
    && echo 'echo "export JAVA_HOME=/usr/java/jdk" >> /root/.bashrc' >> ${DEFAULT_DIR}/install_jdk.sh \
    && chmod 777 ${DEFAULT_DIR}/install_jdk.sh \
    && /bin/bash ${DEFAULT_DIR}/install_jdk.sh \
    && rm -rf *.rpm \
    && rm ${DEFAULT_DIR}/install_jdk.sh

ENV JAVA_HOME /usr/java/jdk

# install maven 3.6.3
ARG MAVEN_VERSION=3.6.3
ARG SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

# build environment
WORKDIR ${DEFAULT_DIR}

COPY thirdparty.zip ${DEFAULT_DIR}/ 

# ccache
RUN yum install -y epel-release && yum install -y ccache 

# env
ENV STARROCKS_THIRDPARTY /var/local/thirdparty
ENV STARROCKS_GCC_HOME /usr

WORKDIR ${DEFAULT_DIR}
COPY start.sh ${DEFAULT_DIR}/
CMD /var/local/start.sh