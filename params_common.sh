GIT_BRANCH=${1:-"main"}
IMAGE_VERSION=${2:-"rc"}
GIT_REPO='https://github.com/StarRocks/starrocks.git'
CONTAINER_NAME_TOOLCHAIN='con_chain'
CONTAINER_NAME_THIRDPARTY='con_thirdparty'
PROXY="http://172.26.92.139:28888"
