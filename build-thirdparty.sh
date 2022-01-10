set -e
curdir=`dirname "$0"`
curdir=`cd "$curdir"; pwd`

IMAGE_NAME_THIRDPARTY='thirdparty'

source $curdir/params.sh

cd sr-thirdparty

echo "========== start to build $IMAGE_NAME_THIRDPARTY..."

docker build -t starrocks/$IMAGE_NAME_THIRDPARTY:$IMAGE_VERSION .

echo "========== build $IMAGE_NAME_THIRDPARTY done..."

cd ..
