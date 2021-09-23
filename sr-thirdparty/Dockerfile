FROM centos:centos7.5.1804
ARG JDK_SOURCE
ENV DEFAULT_DIR /var/local

ARG GCC_VERSION
ARG GCC_URL

# install dependencies and build gcc
RUN yum install -y epel-release bzip2 wget git gcc-c++ libstdc++-static byacc flex automake libtool binutils-devel bison ncurses-devel make mlocate unzip patch which vim-common redhat-lsb-core zip libcurl-devel \
  && yum install -y ccache \
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

# build environment
WORKDIR ${DEFAULT_DIR}

COPY thirdparty ${DEFAULT_DIR}/thirdparty 

# env
ENV STARROCKS_THIRDPARTY /var/local/thirdparty
ENV STARROCKS_GCC_HOME /usr

WORKDIR ${DEFAULT_DIR}

COPY llvm ${DEFAULT_DIR}/llvm
ENV PATH "$PATH:/var/local/llvm/bin"

# maven
COPY maven /usr/share/maven
RUN ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven

# cmake
COPY cmake /usr/share/cmake
RUN ln -s /usr/share/cmake/bin/cmake /usr/bin/cmake

# CMD /var/local/start.sh
CMD top