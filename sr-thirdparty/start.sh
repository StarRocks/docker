mkdir /var/local/thirdparty
tar -xvJf /var/local/thirdparty.tar.xz -C /var/local/thirdparty --strip-components 1

mkdir /var/local/llvm
tar -xvJf /var/local/clang-llvm.tar.xz -C /var/local/llvm --strip-components 1
top