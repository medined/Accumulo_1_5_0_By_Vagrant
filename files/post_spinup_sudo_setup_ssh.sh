#
# Add nodes to known hosts to avoid the security question.
rm -f /etc/ssh/ssh_known_hosts
ssh-keyscan -t rsa affy-master affy-slave1 affy-slave2 > /etc/ssh/ssh_known_hosts
ssh-keyscan -t dsa affy-master affy-slave1 affy-slave2 >> /etc/ssh/ssh_known_hosts
