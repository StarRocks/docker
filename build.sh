set -e
curdir=`dirname "$0"`
curdir=`cd "$curdir"; pwd`

IMAGE_NAME_TOOLCHAIN='toolchain'
IMAGE_NAME_THIRDPARTY='thirdparty'

source $curdir/params.sh

image=$(docker images| grep $IMAGE_NAME_TOOLCHAIN || echo 0)
if [ ${#image} != 1 ]; then
    echo "======= $IMAGE_NAME_TOOLCAHIN already exist, remove it mannauly if new build is needed ======="
else 
    echo "======= $IMAGE_NAME_TOOLCHAIN not found, start to build ======="
    ./build-toolchain.sh
fi

if [[ ! -d "starrocks" ]]; then  
    echo "===== starrocks not found, start to clone ==== "
    git clone -b $GIT_BRANCH $GIT_REPO
    echo "===== starrocks clone finshed ==== "
else 
    echo "===== starrocks repo already exited, checkout to $GIT_BRANCH ==== "
    cd starrocks
    git checkout $GIT_BRANCH
    git pull
    cd ..
fi 

if [[ ! -f "starrocks/thirdparty/vars.sh" ]]; then
    echo "vars.sh not found"
    exit 1
fi

#build thirdparty libraries if necessary
if [[ ! -f starrocks/thirdparty/installed/lib/mariadb/libmariadbclient.a ]]; then
    echo "Thirdparty libraries need to be build ..."

    echo "========== start $CONTAINER_NAME_TOOLCHAIN..."
    docker run -it --name $CONTAINER_NAME_TOOLCHAIN -d -v $curdir/starrocks:/var/local/starrocks starrocks/$IMAGE_NAME_TOOLCHAIN:$IMAGE_VERSION
    docker cp $curdir/sr-toolchain/build-thirdparty.sh $CONTAINER_NAME_TOOLCHAIN:/var/local

    echo "========== start to build thirdpaty..."
    docker exec -it $CONTAINER_NAME_TOOLCHAIN /bin/bash /var/local/build-thirdparty.sh
    docker rm -f $CONTAINER_NAME_TOOLCHAIN
fi 

echo "========== start to transfer thirdparty..."
rm -rf sr-thirdparty/thirdparty
cp -r $curdir/starrocks/thirdparty sr-thirdparty
rm -r sr-thirdparty/thirdparty/src

./build-thirdparty.sh