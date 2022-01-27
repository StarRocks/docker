# container name

CONTAINER_NAME_TOOLCHAIN='con_chain-1'
CONTAINER_NAME_THIRDPARTY='con_thirdparty'

# dependency

## git repo
GIT_REPO='https://github.com/StarRocks/starrocks.git'
GIT_BRANCH='main'

IMAGE_VERSION='v1'

# clang_llvm arch detection
CLANG_LLVM_DOWNLOAD_URL='https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang+llvm-10.0.0-x86_64-linux-sles11.3.tar.xz'
MACHINE_TYPE=$(uname -m)
if [[ "${MACHINE_TYPE}" == "aarch64" ]]; then
	CLANG_LLVM_DOWNLOAD_URL='https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang+llvm-10.0.0-aarch64-linux-gnu.tar.xz'
fi