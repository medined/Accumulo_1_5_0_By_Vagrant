#!/bin/bash

if [ -f /.vagrant_build_done ]; then
    echo "Script already run. Exiting."
    exit
fi

echo "" > /etc/hosts

source /vagrant/files/setup.sh
source /vagrant/files/install_hadoop.sh
source /vagrant/files/install_zookeeper.sh
source /vagrant/files/install_accumulo.sh

chown -R vagrant:vagrant $BASE_DIR

# Do not let this run again
touch /.vagrant_build_done
