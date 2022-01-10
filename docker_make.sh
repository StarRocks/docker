set -e
curdir=`dirname "$0"`
curdir=`cd "$curdir"; pwd`

IMAGE_NAME_TOOLCHAIN='toolchain'
IMAGE_NAME_THIRDPARTY='dev-env'

source $curdir/params.sh

RUNNING=$(docker ps -a | grep $CONTAINER_NAME_TOOLCHAIN || echo 0)
if [ ${#RUNNING} != 1 ]; then
    echo "======= $CONTAINER_NAME_TOOLCHAIN is exist."
    exit 1
else 
    echo "======= $CONTAINER_NAME_TOOLCHAIN will run."
fi

wget -O jdk.rpm "$JDK_RPM_SOURCE"

if [[ ! -f "jdk.rpm" ]]; then
    echo "jdk.rpm found"
    exit 1
fi

cd sr-toolchain
rm -rf starrocks
git clone -b $GIT_BRANCH $GIT_REPO

if [[ ! -d "starrocks" ]]; then  
    echo "starrocks not found"
    exit 1
fi 

if [[ ! -f "starrocks/thirdparty/vars.sh" ]]; then
    echo "vars.sh not found"
    exit 1
fi

cp ../jdk.rpm .
if [[ ! -f "jdk.rpm" ]]; then
    echo "jdk not found"
    exit 1
fi

copy_num=$(sed -n  '/===== Downloading thirdparty archives...done/=' starrocks/thirdparty/download-thirdparty.sh)
if [[ copy_num == 0 ]]; then
    echo "===== cannot generate download scripts"
    exit 1
fi
head -n $copy_num starrocks/thirdparty/download-thirdparty.sh > starrocks/thirdparty/download-for-docker-thirdparty.sh

# download thirdparty src
if [[ ! -d "starrocks/thirdparty/src" ]]; then  
    echo '========== download thirdparty src...'
    bash starrocks/thirdparty/download-for-docker-thirdparty.sh
fi 

echo "========== start to build $IMAGE_NAME_TOOLCHAIN..."

# build $IMAGE_NAME_TOOLCHAIN && copy thirdparty from CONTAINER(env_gen)
docker build \
-t starrocks/$IMAGE_NAME_TOOLCHAIN:$IMAGE_VERSION \
--build-arg GCC_VERSION=$GCC_VERSION \
--build-arg GCC_URL=$GCC_URL \
--build-arg CMAKE_VERSION=$CMAKE_VERSION \
--build-arg CMAKE_DOWNLOAD_URL=$CMAKE_DOWNLOAD_URL \
--build-arg MAVEN_VERSION=$MAVEN_VERSION \
--build-arg SHA=$SHA \
--build-arg BASE_URL=$BASE_URL .

echo "========== build $IMAGE_NAME_TOOLCHAIN... done"

echo "========== start $CONTAINER_NAME_TOOLCHAIN..."
docker run -it --name $CONTAINER_NAME_TOOLCHAIN -d starrocks/$IMAGE_NAME_TOOLCHAIN:$IMAGE_VERSION

echo "========== start to build thirdpaty..."

docker exec -it $CONTAINER_NAME_TOOLCHAIN /bin/bash /var/local/install.sh

echo "========== start to transfer thirdparty..."
docker cp $CONTAINER_NAME_TOOLCHAIN:/var/local/thirdparty ../sr-thirdparty/
rm -rf jdk.rpm

cd ../sr-thirdparty
if [[ ! -d "thirdparty" ]]; then
    echo "thirdparty not found"
    exit 1
fi
rm -rf thirdparty/src

cp ../jdk.rpm .
if [[ ! -f "jdk.rpm" ]]; then
    echo "jdk not found"
    exit 1
fi

wget -O clang-llvm.tar.xz "$LLVM_SOURCE"

if [[ ! -f "clang-llvm.tar.xz" ]]; then
    echo "clang-llvm.tar.xz found"
    exit 1
fi

mkdir llvm && tar -xvJf clang-llvm.tar.xz -C llvm --strip-components 1

wget -O cmake.tar "$CMAKE_SOURCE"
rm -rf cmake && mkdir cmake && tar -xvf cmake.tar -C cmake --strip-components 1
rm -rf cmake.tar

docker cp $CONTAINER_NAME_TOOLCHAIN:/usr/share/maven ../sr-thirdparty/

echo "========== start to build $IMAGE_NAME_THIRDPARTY..."

docker build -t starrocks/$IMAGE_NAME_THIRDPARTY:$GIT_BRANCH-$IMAGE_VERSION \
--build-arg GCC_VERSION=$GCC_VERSION \
--build-arg GCC_URL=$GCC_URL .

echo "========== build $IMAGE_NAME_THIRDPARTY done..."

