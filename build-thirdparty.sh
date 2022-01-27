set -e
curdir=`dirname "$0"`
curdir=`cd "$curdir"; pwd`

IMAGE_NAME_THIRDPARTY='thirdparty'

source $curdir/params.sh

cd sr-thirdparty

echo "========== start to download clang_llvm..."
# download clang_llvm
wget $CLANG_LLVM_DOWNLOAD_URL -O clang_llvm.tar.xz
mkdir clang_llvm
tar -xf clang_llvm.tar.xz -C clang_llvm --strip-components=1

echo "========== start to build $IMAGE_NAME_THIRDPARTY..."

docker build -t starrocks/$IMAGE_NAME_THIRDPARTY:$IMAGE_VERSION .

echo "========== build $IMAGE_NAME_THIRDPARTY done..."

cd ..
