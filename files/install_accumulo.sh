#!/bin/bash

export MY_ACCUMULO_VERSION=1.5.0

mkdir -p $BASE_DIR/software/accumulo-$MY_ACCUMULO_VERSION $BASE_DIR/bin/accumulo-$MY_ACCUMULO_VERSION

# Accumulo is extracted into a software directory and then installed
# into a bin directory.

tar xvf /vagrant/files/accumulo-1.5.0-src.tar.gz -C $BASE_DIR/software
ln -s $BASE_DIR/software/accumulo-$MY_ACCUMULO_VERSION $BASE_DIR/software/accumulo

pushd $BASE_DIR/software/accumulo-$MY_ACCUMULO_VERSION; mvn -DskipTests package -P assemble; popd
echo "Compiled accumulo"

tar xfz $BASE_DIR/software/accumulo/assemble/target/accumulo-$MY_ACCUMULO_VERSION-bin.tar.gz -C $BASE_DIR/bin

ln -s $BASE_DIR/bin/accumulo-$MY_ACCUMULO_VERSION $BASE_DIR/bin/accumulo

mkdir -p $BASE_DIR/bin/accumulo/lib/ext $BASE_DIR/bin/accumulo/logs $BASE_DIR/bin/accumulo/walogs
echo "Created ext, logs, and walogs directory."

cp $BASE_DIR/bin/accumulo/conf/examples/512MB/standalone/* $BASE_DIR/bin/accumulo/conf

cp /vagrant/files/config/accumulo/* $BASE_DIR/bin/accumulo/conf
