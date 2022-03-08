FROM docker.io/library/centos:centos7.9.2009

RUN yum install -y epel-release && yum install -y ccache

ENV DEFAULT_DIR /var/local

ARG GCC_VERSION
ARG GCC_URL

# install dependencies and build gcc
COPY ./install_env_gcc.sh ${DEFAULT_DIR}/
RUN /bin/bash ${DEFAULT_DIR}/install_env_gcc.sh ${GCC_URL} ${GCC_VERSION}
ENV STARROCKS_GCC_HOME /usr

# install jdk
COPY ./java.tar.gz ${DEFAULT_DIR}/
COPY ./install_java.sh ${DEFAULT_DIR}/
RUN /bin/bash ${DEFAULT_DIR}/install_java.sh
ENV JAVA_HOME /usr/java/jdk

# build cmake
COPY cmake /usr/share/cmake
RUN ln -s /usr/share/cmake/bin/cmake /usr/bin/cmake

ENV https_proxy "http://172.26.92.139:28888"

ARG MAVEN_VERSION
ARG SHA
ARG BASE_URL
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven

# build environment
WORKDIR ${DEFAULT_DIR}

# clone lastest source code, download and build thirdparty
COPY starrocks ${DEFAULT_DIR}/starrocks
COPY install.sh ${DEFAULT_DIR}/
CMD top

