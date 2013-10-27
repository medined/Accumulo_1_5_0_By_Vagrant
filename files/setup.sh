echo "vm.swappiness = 10" >> /etc/sysctl.conf
sysctl vm.swappiness=10

addgroup supergroup
adduser root supergroup
adduser vagrant supergroup

##
## INSTALL PACKAGES
##

# setup a source for maven3 which is required by Accumulo.
echo "deb http://ppa.launchpad.net/natecarlson/maven3/ubuntu precise main" | tee -a /etc/apt/sources.list
echo "deb-src http://ppa.launchpad.net/natecarlson/maven3/ubuntu precise main" | tee -a /etc/apt/sources.list
apt-get update

apt-get -y install openjdk-6-jdk subversion expect
#apt-get -y install curl git openssh-server openssh-client terminator openjdk-6-jdk subversion screen g++ make meld build-essential g++-multilib
apt-get -y --force-yes install maven3

#
# Set the locale
locale-gen en_US

# remove the symbolic link to maven2. You can still access it via /usr/share/maven2/bin/mvn
ln -s /usr/share/maven3/bin/mvn /usr/bin/mvn

export VFILES=/vagrant/files
export BASE_DIR=/home/vagrant/accumulo_home

cat > /etc/profile.d/accumulo_setup.sh <<EOF
export ACCUMULO_HOME=/home/vagrant/accumulo_home/bin/accumulo
export HADOOP_PREFIX=/home/vagrant/accumulo_home/bin/hadoop
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64
export ZOOKEEPER_HOME=/home/vagrant/accumulo_home/bin/zookeeper

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/vagrant_ruby/bin
export PATH=\$ACCUMULO_HOME/bin:\$PATH
export PATH=\$HADOOP_PREFIX/bin:\$PATH
export PATH=/usr/lib/jvm/java-6-openjdk-amd64/bin:\$PATH
export PATH=\$ZOOKEEPER_HOME/bin:\$PATH
EOF

source /etc/profile.d/accumulo_setup.sh

export HADOOP_VERSION=hadoop-1.0.4
export ZOOKEEPER_VERSION=zookeeper-3.4.3
export LOGFILE=$HOME/build.log
export PASSWORD=`openssl passwd -1 password`

mkdir -p $BASE_DIR/software $BASE_DIR/bin 

mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh
su vagrant -c "ssh-keygen -t rsa -P '' -f /home/vagrant/.ssh/id_rsa"

mkdir -p /vagrant/files/ssh
cp /home/vagrant/.ssh/id_rsa.pub /vagrant/files/ssh/`hostname`.pub

