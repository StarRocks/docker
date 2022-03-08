FROM docker.io/library/centos:centos7.9.2009

ENV DEFAULT_DIR /var/local
ARG PROXY
ENV https_proxy ${PROXY}
# build environment
WORKDIR ${DEFAULT_DIR}

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

# install cmake
COPY cmake /usr/share/cmake
RUN ln -s /usr/share/cmake/bin/cmake /usr/bin/cmake

# install mvn
ARG BASE_URL
ARG MAVEN_VERSION
ARG SHA
COPY ./install_mvn.sh ${DEFAULT_DIR}/
RUN /bin/bash ${DEFAULT_DIR}/install_mvn.sh ${BASE_URL} ${MAVEN_VERSION} ${SHA}
ENV MAVEN_HOME /usr/share/maven

# ===== different =====

# install llvm
COPY llvm ${DEFAULT_DIR}/llvm
ENV PATH "$PATH:/var/local/llvm/bin"

COPY thirdparty ${DEFAULT_DIR}/thirdparty 

# env
ENV STARROCKS_THIRDPARTY /var/local/thirdparty
ENV STARROCKS_GCC_HOME /usr

CMD top