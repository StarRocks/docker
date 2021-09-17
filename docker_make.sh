set -e
curdir=`dirname "$0"`
curdir=`cd "$curdir"; pwd`

IMAGE_NAME_TOOLCHAIN='toolchain'
IMAGE_NAME_THIRDPARTY='thirdparty'

source params.sh

RUNNING=$(docker ps -a | grep $CONTAINER_NAME_TOOLCHAIN || echo 0)
if [ ${#RUNNING} != 1 ]; then
    echo "======= $CONTAINER_NAME_TOOLCHAIN is exist."
    exit 1
else 
    echo "======= $CONTAINER_NAME_TOOLCHAIN will be built."
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

source starrocks/thirdparty/vars.sh

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

echo "========== transfer thirdparty..."
docker cp $CONTAINER_NAME_TOOLCHAIN:/var/local/thirdparty ../sr-thirdparty/
rm -rf jdk.rpm

cd ../sr-thirdparty
if [[ ! -d "thirdparty" ]]; then
    echo "thirdparty not found"
    exit 1
fi
rm -rf thirdparty/src
zip -r thirdparty.zip thirdparty
rm -rf thirdparty

cp ../jdk.rpm .
if [[ ! -f "jdk.rpm" ]]; then
    echo "jdk not found"
    exit 1
fi

echo "========== start to build $IMAGE_NAME_THIRDPARTY..."

docker build -t starrocks/$IMAGE_NAME_THIRDPARTY:$IMAGE_VERSION \
--build-arg GCC_VERSION=$GCC_VERSION \
--build-arg GCC_URL=$GCC_URL \
--build-arg CMAKE_VERSION=$CMAKE_VERSION \
--build-arg CMAKE_DOWNLOAD_URL=$CMAKE_DOWNLOAD_URL \
--build-arg MAVEN_VERSION=$MAVEN_VERSION \
--build-arg SHA=$SHA \
--build-arg BASE_URL=$BASE_URL .

echo "========== build $IMAGE_NAME_THIRDPARTY done..."

