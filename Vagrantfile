
master_node_name = "affy-master.example.com"
slave1_node_name = "affy-slave1.example.com"
slave2_node_name = "affy-slave2.example.com"

Vagrant.configure("2") do |config|
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.vm.define :master do |master|
    master.vm.box = "precise64"
    master.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"]  = "4096"
    end
    master.vm.provider :virtualbox do |v|
      v.name = master_node_name
      v.customize ["modifyvm", :id, "--memory", "4096"]
    end
    master.vm.network :private_network, ip: "10.211.55.100"
    master.vm.hostname = master_node_name
    #master.vm.provision :shell, :path => "master_node.sh"
    master.vm.provision "puppet" do |puppet|
      puppet.options = "--verbose --debug"
      puppet.facter = {
        "vagrant" => "1",
      }
    end
  end

  config.vm.define :slave1 do |slave1|
    slave1.vm.box = "precise64"
    slave1.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"]  = "4096"
    end
    slave1.vm.provider :virtualbox do |v|
      v.name = slave1_node_name
      v.customize ["modifyvm", :id, "--memory", "4096"]
    end
    slave1.vm.network :private_network, ip: "10.211.55.101"
    slave1.vm.hostname = slave1_node_name
    slave1.vm.provision :shell, :path => "slave_node.sh"
  end

  config.vm.define :slave2 do |slave2|
    slave2.vm.box = "precise64"
    slave2.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"]  = "4096"
    end
    slave2.vm.provider :virtualbox do |v|
      v.name = slave2_node_name
      v.customize ["modifyvm", :id, "--memory", "4096"]
    end
    slave2.vm.network :private_network, ip: "10.211.55.102"
    slave2.vm.hostname = slave2_node_name
    slave2.vm.provision :shell, :path => "slave_node.sh"
    config.ssh.forward_x11 = true
  end

end

