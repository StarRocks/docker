# container name

CONTAINER_NAME_TOOLCHAIN='con_chain_1'
CONTAINER_NAME_THIRDPARTY='con_thirdparty'

# dependency

## git repo
GIT_REPO='https://github.com/StarRocks/starrocks.git'
GIT_BRANCH='branch-2.0'

IMAGE_VERSION='v1'

## JDK
JDK_RPM_SOURCE='http://starrocks-thirdparty.oss-cn-zhangjiakou.aliyuncs.com/jdk.rpm'

## llvm
LLVM_SOURCE='http://starrocks-thirdparty.oss-cn-zhangjiakou.aliyuncs.com/clang-llvm.tar.xz'

## CMAKE
CMAKE_SOURCE='https://github.com/Kitware/CMake/releases/download/v3.22.2/cmake-3.22.2-Linux-x86_64.tar.gz'

## GCC
GCC_VERSION=10.3.0
GCC_URL="https://mirrors.ustc.edu.cn/gnu/gcc/gcc-$GCC_VERSION"

## CMAKE
CMAKE_VERSION=3.22.2
CMAKE_DOWNLOAD_URL='https://cmake.org/files/v3.22/cmake-3.22.2-linux-x86_64.tar.gz'

## MAVEN
MAVEN_VERSION=3.6.3
SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
BASE_URL="https://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries"
