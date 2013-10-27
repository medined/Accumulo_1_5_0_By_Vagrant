export HBASE_DIR=$BASE_DIR/bin

mkdir -p $HBASE_DIR
mkdir -p $BASE_DIR/data/hadoop_tmp_dir
chmod 755 $BASE_DIR/data/hadoop_tmp_dir

tar xfz $VFILES/$HADOOP_VERSION.tar.gz -C $HBASE_DIR
ln -s $HBASE_DIR/$HADOOP_VERSION $HBASE_DIR/hadoop

cp $VFILES/config/hadoop/* $HBASE_DIR/hadoop/conf
