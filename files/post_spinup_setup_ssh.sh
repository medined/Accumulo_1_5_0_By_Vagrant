sudo /vagrant/files/post_spinup_sudo_setup_ssh.sh

#
# Copy the public keys to the authorized keys file.
cat /vagrant/files/ssh/affy-master.pub >> /home/vagrant/.ssh/authorized_keys
cat /vagrant/files/ssh/affy-slave1.pub >> /home/vagrant/.ssh/authorized_keys
cat /vagrant/files/ssh/affy-slave2.pub >> /home/vagrant/.ssh/authorized_keys

