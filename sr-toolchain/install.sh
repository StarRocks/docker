DEFAULT_DIR='/var/local'
cd $DEFAULT_DIR/starrocks/thirdparty
/bin/bash build-thirdparty.sh
mv $DEFAULT_DIR/starrocks/thirdparty $DEFAULT_DIR
rm -rf $DEFAULT_DIR/starrocks