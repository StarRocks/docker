set -eo pipefail

curdir=$(dirname "$0")
curdir=$(
    cd "$curdir"
    pwd
)

BUILD_TYPE=${1:?"The first parameter is required, select branch/tag/pr"}
GIT_BRANCH=${2:?"The second parameter is required, select branch_name/tag_name/pr_id"}
IMAGE_VERSION=${3:-"rc"}
PROXY=${4:-""}
PR_TARGET_BRANCH=${5:-"main"}

GIT_REPO='https://github.com/StarRocks/starrocks.git'
CONTAINER_NAME_TOOLCHAIN="con_chain_"${GIT_BRANCH}
CONTAINER_NAME_THIRDPARTY='con_thirdparty'

IMAGE_NAME_TOOLCHAIN='toolchain'
IMAGE_NAME_THIRDPARTY='dev-env'

MACHINE_TYPE=$(uname -m)
echo "===== build image on $MACHINE_TYPE"

PARAMS_TARGET=params_source_$MACHINE_TYPE.sh

source $curdir/$PARAMS_TARGET

echo "===== proxy is $PROXY"
export https_proxy=$PROXY

RUNNING=$(docker ps -a | grep $CONTAINER_NAME_TOOLCHAIN || echo 0)
if [ ${#RUNNING} != 1 ]; then
    docker rm -f $CONTAINER_NAME_TOOLCHAIN
fi

wget -O java.tar.gz "$JDK_SOURCE"
if [[ ! -f "java.tar.gz" ]]; then
    echo "ERROR: java.tar.gz not found"
    exit 1
fi

wget -O cmake.tar "$CMAKE_SOURCE"
rm -rf cmake && mkdir cmake && tar -xvf cmake.tar -C cmake --strip-components 1
rm -rf cmake.tar

rm -rf sr-toolchain/starrocks

if [[ $BUILD_TYPE == "branch" ]]; then
    git clone -b $GIT_BRANCH $GIT_REPO sr-toolchain/starrocks

elif [[ $BUILD_TYPE == "tag" ]]; then
    # GIT_BRANCH will be tag name when BUILD_TYPE is tag
    git clone -b main $GIT_REPO sr-toolchain/starrocks
    cd sr-toolchain/starrocks
    git checkout $GIT_BRANCH
    cd $curdir

elif [[ $BUILD_TYPE == "pr" ]]; then
    # GIT_BRANCH will be pr id when BUILD_TYPE is pr
    git clone $GIT_REPO sr-toolchain/starrocks
    cd sr-toolchain/starrocks
    git config --global user.email "you@example.com"
    git config --global user.name "Your Name"
    git fetch origin pull/${GIT_BRANCH}/head:${GIT_BRANCH}
    git checkout $GIT_BRANCH

    # merge pr commit to target_branch: main|branch-2.3 and so on, the merge branch is merge_pr.
    git branch -D merge_pr || true
    git checkout $PR_TARGET_BRANCH
    git checkout -b merge_pr
    git merge --squash --no-edit ${GIT_BRANCH} || (echo "Merge main conflict, please check." && git reset --merge && git branch -D ${GIT_BRANCH} && git checkout $PR_TARGET_BRANCH && exit -1)

    cd $curdir
    IMAGE_VERSION="pr-"$GIT_BRANCH

else
    echo "ERROR: only supports branch or pr"
    exit 1
fi

if [[ ! -d "sr-toolchain/starrocks" ]]; then
    echo "ERROR: starrocks not found"
    exit 1
fi

if [[ ! -f "sr-toolchain/starrocks/thirdparty/vars.sh" ]]; then
    echo "ERROR: vars.sh not found"
    exit 1
fi

cp java.tar.gz sr-toolchain/
if [[ ! -f "sr-toolchain/java.tar.gz" ]]; then
    echo "ERROR: jdk not found"
    exit 1
fi

cp -r cmake sr-toolchain/
cp install_env_gcc_$MACHINE_TYPE.sh sr-toolchain/install_env_gcc.sh
cp install_java_$MACHINE_TYPE.sh sr-toolchain/install_java.sh
cp install_mvn_$MACHINE_TYPE.sh sr-toolchain/install_mvn.sh

copy_num=$(sed -n '/===== Downloading thirdparty archives...done/=' sr-toolchain/starrocks/thirdparty/download-thirdparty.sh)
if [[ copy_num == 0 ]]; then
    echo "ERROR: cannot generate download scripts"
    exit 1
fi
head -n $copy_num sr-toolchain/starrocks/thirdparty/download-thirdparty.sh >sr-toolchain/starrocks/thirdparty/download-for-docker-thirdparty.sh

echo '===== start to download thirdparty src...'
bash sr-toolchain/starrocks/thirdparty/download-for-docker-thirdparty.sh

# build toolchain
echo "===== start to build $IMAGE_NAME_TOOLCHAIN..."
cd sr-toolchain
docker build \
    -t starrocks/$IMAGE_NAME_TOOLCHAIN:$IMAGE_VERSION \
    --build-arg PROXY=$PROXY \
    --build-arg GCC_VERSION=$GCC_VERSION \
    --build-arg GCC_URL=$GCC_URL \
    --build-arg MAVEN_VERSION=$MAVEN_VERSION \
    --build-arg SHA=$SHA \
    --build-arg BASE_URL=$BASE_URL .

echo "===== start $CONTAINER_NAME_TOOLCHAIN..."
docker run -it --name $CONTAINER_NAME_TOOLCHAIN -d starrocks/$IMAGE_NAME_TOOLCHAIN:$IMAGE_VERSION

echo "===== start to build thirdparty"
docker exec $CONTAINER_NAME_TOOLCHAIN /bin/bash /var/local/install.sh || exit 1

echo "===== start to transfer thirdparty..."
rm -rf ../sr-thirdparty/thirdparty
docker cp $CONTAINER_NAME_TOOLCHAIN:/var/local/thirdparty ../sr-thirdparty/
rm -rf jdk.rpm

cd ..

cp java.tar.gz sr-thirdparty/
if [[ ! -f "sr-thirdparty/java.tar.gz" ]]; then
    echo "ERROR: jdk not found"
    exit 1
fi

cp -r cmake sr-thirdparty/
cp install_env_gcc_$MACHINE_TYPE.sh sr-thirdparty/install_env_gcc.sh
cp install_java_$MACHINE_TYPE.sh sr-thirdparty/install_java.sh
cp install_mvn_$MACHINE_TYPE.sh sr-thirdparty/install_mvn.sh

# build thirdparty
cd sr-thirdparty
if [[ ! -d "thirdparty" ]]; then
    echo "ERROR: thirdparty not found"
    exit 1
fi
rm -rf thirdparty/src

mkdir -p llvm/bin
wget -O llvm/bin/clang-format "$LLVM_SOURCE"
chmod +x llvm/bin/clang-format

echo "===== start to build $IMAGE_NAME_THIRDPARTY..."
docker build \
    -t starrocks/$IMAGE_NAME_THIRDPARTY:$GIT_BRANCH-$IMAGE_VERSION \
    --build-arg PROXY=$PROXY \
    --build-arg GCC_VERSION=$GCC_VERSION \
    --build-arg GCC_URL=$GCC_URL \
    --build-arg MAVEN_VERSION=$MAVEN_VERSION \
    --build-arg SHA=$SHA \
    --build-arg BASE_URL=$BASE_URL .

docker rm -f $CONTAINER_NAME_TOOLCHAIN

echo "**********************************************"
echo " Successfully build StarRocks-dev-env image "
echo "**********************************************"

exit 0
