set -e
curdir=`dirname "$0"`
curdir=`cd "$curdir"; pwd`

cd sr_build_env_gen_image
rm -rf starrocks
git clone https://github.com/StarRocks/starrocks.git

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

echo '========== build build_env_gen...'
# build build_env_gen && copy thirdparty from CONTAINER(env_gen)
docker build -t starrocks/build_env_gen .
echo '========== build_env_gen... done'
# result=$(docker ps | grep build_env_gen)

# if [[ -n $result ]]; then
#     echo 'build_env_gen is runnning'
#     docker rm -f build_env_gen
# fi

echo '========== start build_env_gen...'

docker run -it --name build_env_gen -d starrocks/build_env_gen

echo '========== transfer thirdparty...'
docker cp build_env_gen:/var/local/thirdparty ../sr_build_env_image/
rm -rf jdk.rpm

cd ../sr_build_env_image
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

echo '========== build build_env...'
docker build -t starrocks/build_env .
# docker run -it --name build_env -d starrocks/build_env
