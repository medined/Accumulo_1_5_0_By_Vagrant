#!/bin/bash

if [ -f /.vagrant_build_done ]; then
    echo "Script already run. Exiting."
    exit
fi

cat > /etc/hosts <<EOF
10.211.55.100   affy-master
10.211.55.101   affy-slave1
10.211.55.102   affy-slave2
EOF

source /vagrant/files/setup.sh
source /vagrant/files/install_hadoop.sh
source /vagrant/files/install_zookeeper.sh
source /vagrant/files/install_accumulo.sh

chown -R vagrant:vagrant $BASE_DIR

# Do not let this run again
touch /.vagrant_build_done
