set -e
curdir=`dirname "$0"`
curdir=`cd "$curdir"; pwd`

IMAGE_NAME_TOOLCHAIN='toolchain'

source $curdir/params.sh

echo "========== start to build $IMAGE_NAME_TOOLCHAIN..."

cd sr-toolchain

# build $IMAGE_NAME_TOOLCHAIN && copy thirdparty from CONTAINER(env_gen)
docker build -t starrocks/$IMAGE_NAME_TOOLCHAIN:$IMAGE_VERSION .

echo "========== build $IMAGE_NAME_TOOLCHAIN... done"
cd ..