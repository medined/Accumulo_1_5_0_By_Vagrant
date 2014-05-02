# Accumulo v1.5.0 By Vagrant

A three node Accumulo cluster running on Ubuntu Precise (12.04). The instance name is 'instance'. The 
user name is 'root' and the password is 'secret'.

1. Install Vagrant
2. vagrant plugin install vagrant-hostmanager
3. Download this project.
4. Run 'vagrant up'
5. Run 'post_spinup.sh'

NOTE: 2014-Mar-26 I ran this project today and ran into a difference. So I changed to manaully configuring Accumulo. Not sure why the behavior has changed and I can't devote time now to investigate.

```
 vagrant ssh master
 accumulo init
   instance: instance
   password: secret
 cd /home/vagrant/accumulo_home/bin/accumulo
 bin/start-all.sh
```

Now you can visit the following URLs in your browser:

<a target="_blank" href='http://affy-master:50095/'>http://affy-master:50095/</a><br/>
<a target="_blank" href='http://affy-master:50070/dfshealth.jsp'>http://affy-master:50070/dfshealth.jsp</a><br/>
<a target="_blank" href='http://affy-master:50030/jobtracker.jsp'>http://affy-master:50030/jobtracker.jsp</a><br/>

You can SSH to the nodes using the following commands. Notice that the hostnames start with 'affy-' but that 
the vagrant nodes do not have the prefix.

```
vagrant ssh master
vagrant ssh slave1
vagrant ssh slave2
```

## Creating .box files so you can restart cluster in five minutes!

Vagrant helps you to package your virtual machine into a .box file. Which can subsequently be used to start your virtual machines very quickly. Once you've
followed the steps above and have a working three-node cluster you can follow the steps below.

```
vagrant package --base affy-master --output virtualbox/affy-master.box
vagrant package --base affy-slave1 --output virtualbox/affy-slave1.box
vagrant package --base affy-slave2 --output virtualbox/affy-slave2.box

vagrant box add -f affy-master virtualbox/affy-master.box
vagrant box add -f affy-slave1 virtualbox/affy-slave1.box
vagrant box add -f affy-slave2 virtualbox/affy-slave2.box

vagrant destroy
```

Now you should be setup to restart your cluster. As the cluster starts, you'll be asked if you want to reformat the hadoop filesystem,
answer N. You can ignore the warnings.

```
cd virtualbox
vagrant up
./post_spinnup.sh
vagrant ssh slave2
accumulo_home/bin/accumulo/bin/start-all.sh
```

## Install Pig on a node

1. vagrant ssh master
2. cd /home/vagrant/accumulo_home/bin
3. tar xvfz /vagrant/files/pig-0.12.0.tar.gz
4. export PATH=/home/vagrant/accumulo_home/bin/pig-0.12.0/bin:$PATH 

If you want pig to always be available update your path in the ~/.bashrc file.


## X-WINDOWS on SLAVE2

The second slave is configured so that X11 port forwarding is automatic when you use 'vagrant ssh slave2'. For 
convenience, I manually installed additional software on that node:

```
sudo apt-get install -y x11-apps
sudo apt-get install -y netbeans
```

## Installing Octave 3.8.1 from Source

See http://www.gnu.org/software/octave/ for more information.

The following steps took about 40 minutes to run. Note that Java will work with Octave even though it says the Java package is not installed.

```
vagrant ssh slave2
cd ~
sudo apt-get install -y g++ gfortran bison
sudo apt-get build-dep -y octave3.2
wget ftp://ftp.gnu.org/gnu/octave/octave-3.8.1.tar.gz
tar xvfz octave-3.8.1.tar.gz
cd octave-3.8.1
./configure --with-java-libdir="/usr/lib/jvm/java-6-openjdk-amd64/jre/lib/amd64/server"
make
sudo make install
```

## Installing D4M v2.5.1

See http://www.mit.edu/~kepner/D4M/gpl.html for more information.

```
cd ~
sudo apt-get install -y unzip
wget http://www.mit.edu/~kepner/D4M/d4m_api_2.5.1.zip
wget http://www.mit.edu/~kepner/D4M/libext_2.5.1.zip
unzip d4m_api_2.5.1.zip
cd d4m_api
unzip ../libext_2.5.1.zip
exit
```

INTERLUDE START
At this point, you can make a .box file of the slave2 instance complete with the Octave and D4M software using the following steps. Once you've made and added this .box file, you can destroy the cluster. Then go into the d4m directory and vagrant up. 

```
vagrant package --base affy-slave2 --output affy-d4m.box
vagrant box add -f affy-d4m affy-d4m.box
```
INTERLUDE END

Once installed, edit TEST/DBsetup.m and examples/3Scaling/2ParallelDatabase/DBsetup.m so that D4M will use your Accumulo instance. I replaced the existing DB definition with the following:

```
hostname='affy-master';
cb_type = 'Accumulo';
instance_name='instance';
username = 'root';
password = 'secret';
DB = DBserver(hostname,cb_type,instance_name, username, password);

ls(DB)
```

The ls(DB) command should list your Accumulo tables. Note there is no semi-colon at the end of the command.

And now you can run all of the examples using the following steps. I am not adding the prompt characters so you can cut and paste easier. 

```
cd ~
octave
addpath('/home/vagrant/d4m_api/matlab_src');
Assoc('','','');
DBinit;
hostname='affy-master';
cb_type = 'Accumulo';
instance_name='instance';
username = 'root';
password = 'secret';
DB = DBserver(hostname,cb_type,instance_name, username, password);
cd /home/vagrant/d4m_api/examples;
d4mTestAllExamples;
```

On my system, the following three tests failed.

```
MP7_CompareResultsTEST
PPL4_FitTransformTEST
pDB07_AdjQueryTEST
```
