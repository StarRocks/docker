set -e
curdir=`dirname "$0"`
curdir=`cd "$curdir"; pwd`

IMAGE_NAME_TOOLCHAIN='toolchain'

source $curdir/params.sh


cd sr-toolchain

echo "========== start to download clang_llvm..."
# download clang_llvm
wget $CLANG_LLVM_DOWNLOAD_URL -O clang_llvm.tar.xz
mkdir clang_llvm
tar -xf clang_llvm.tar.xz -C clang_llvm --strip-components=1

echo "========== start to build $IMAGE_NAME_TOOLCHAIN..."
# build $IMAGE_NAME_TOOLCHAIN && copy thirdparty from CONTAINER(env_gen)
docker build -t starrocks/$IMAGE_NAME_TOOLCHAIN:$IMAGE_VERSION .

echo "========== build $IMAGE_NAME_TOOLCHAIN... done"
cd ..