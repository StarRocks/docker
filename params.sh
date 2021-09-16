# container name

CONTAINER_NAME_BUILD_ENV_GEN='con_build_env_gen'
CONTAINER_NAME_BUILD_ENV='con_build_env'

# dependency

## git repo
GIT_REPO='https://github.com/StarRocks/starrocks.git'
GIT_BRANCH='main'

IMAGE_VERSION=$GIT_BRANCH

## JDK
JDK_RPM_SOURCE='http://starrocks-thirdparty.oss-cn-zhangjiakou.aliyuncs.com/jdk.rpm'

## GCC
GCC_VERSION=10.3.0
GCC_URL=https://mirrors.ustc.edu.cn/gnu/gcc/gcc-$GCC_VERSION

## CMAKE
CMAKE_VERSION=3.16.3
CMAKE_DOWNLOAD_URL=https://cmake.org/files/v3.16/cmake-$CMAKE_VERSION.tar.gz

## MAVEN
MAVEN_VERSION=3.6.3
SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
BASE_URL=https://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries