#!/bin/bash

export ZBASE_DIR=$BASE_DIR/bin

rm -rf $ZBASE_DIR/zookeeper
rm -rf $ZBASE_DIR/$ZOOKEEPER_VERSION
rm -rf $BASE_DIR/data/zookeeper_tmp_dir
mkdir -p $BASE_DIR/data/zookeeper_tmp_dir
chmod 777 $BASE_DIR/data/zookeeper_tmp_dir

tar xfz $VFILES/$ZOOKEEPER_VERSION.tar.gz -C $ZBASE_DIR
ln -s $ZBASE_DIR/$ZOOKEEPER_VERSION $ZBASE_DIR/zookeeper
cp $VFILES/zoo.cfg $ZBASE_DIR/zookeeper/conf/zoo.cfg

