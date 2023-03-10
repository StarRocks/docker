#!/bin/bash
set -eo pipefail

DEFAULT_DIR='/var/local'
cp -r $DEFAULT_DIR/starrocks/thirdparty $DEFAULT_DIR/thirdparty
ln -s $DEFAULT_DIR/thirdparty $DEFAULT_DIR/starrocks/thirdparty
cp $DEFAULT_DIR/starrocks/env.sh $DEFAULT_DIR/
cd $DEFAULT_DIR/thirdparty && bash build-thirdparty.sh
rm -rf $DEFAULT_DIR/starrocks
rm $DEFAULT_DIR/env.sh
