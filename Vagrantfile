# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
 
  config.ssh.insert_key = false

  ansible_groups= {
   "vyos_routers" => [
        "router3",
        "router2",
        ],
   "openbsd_vps" => [
        "vps1",
        ],
   "openbsd_fw"  => [
        "fw1",
        "vps1",
        "vpnvps1",
        ],
  } 
 
  config.vm.define "router3", autostart: true do |router3|
    router3.vm.box="higebu/vyos"
    router3.vm.box_check_update = false
    router3.vm.synced_folder ".", "/vagrant", disabled: true
    router3.vm.hostname ="router3"
    router3.vm.box_check_update = false
    router3.vm.network "private_network", ip: "10.0.0.253" , netmask: "255.255.255.0",
      virtualbox__intnet: "fakeinternet"
    router3.vm.provider "virtualbox" do |vb|
      vb.gui = false
	  vb.name = "router3"
    end
    router3.vm.provision "ansible" do |ansible|
      ansible.groups = ansible_groups
      ansible.playbook = "provisioning/playbook.yml"
    end

  end	

  config.vm.define "router2", autostart: true do |router2|
    router2.vm.box="higebu/vyos"
    router2.vm.box_check_update = false
    router2.vm.synced_folder ".", "/vagrant", disabled: true
    router2.vm.hostname ="router2"
    router2.vm.box_check_update = false
    router2.vm.network "private_network", ip: "10.0.0.252" , netmask: "255.255.255.0",
	  virtualbox__intnet: "fakeinternet"
    router2.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "256"
      vb.name = "router2"
    end
    router2.vm.provision "ansible" do |ansible|
      ansible.groups = ansible_groups
      ansible.playbook = "provisioning/playbook.yml"
    end   
  end	  

  config.vm.define "router1", autostart: true do |router1|
    router1.vm.box="trombik/ansible-openbsd-6.0-amd64"
    router1.vm.box_check_update = false
    router1.vm.synced_folder ".", "/vagrant", disabled: true
    router1.vm.hostname ="router1"
    router1.vm.box_check_update = false
    router1.vm.network "private_network", ip: "10.0.0.251" , netmask: "255.255.255.0",
      virtualbox__intnet: "fakeinternet"
    router1.vm.network "private_network", ip: "172.31.3.251" , netmask: "255.255.255.0",
      virtualbox__intnet: "isp"
    router1.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "256"
      vb.name = "router1"
    end
    router1.vm.provision "shell", inline: <<-SHELL
                route delete default
                echo "10.0.0.252" > /etc/mygate
                route add -inet 0/0 10.0.0.252
                sh -c "echo 'interface \\"em0\\" { ignore routers;}' >> /etc/dhclient.conf"
                ln -sf /usr/local/bin/python /usr/bin/python
    SHELL

    router1.vm.provision "ansible" do |ansible|
      ansible.groups = ansible_groups
      ansible.playbook = "provisioning/playbook.yml"
    end
 
 
  end  

  config.vm.define "vps1", autostart: true do |vps1|
    vps1.vm.synced_folder ".", "/vagrant", disabled: true
    vps1.vm.hostname ="vps1"
    vps1.vm.box="trombik/ansible-openbsd-6.0-amd64"
    vps1.vm.box_check_update = false
    vps1.vm.network "private_network", ip: "10.0.0.10" , netmask: "255.255.255.0",
      virtualbox__intnet: "fakeinternet"
    vps1.vm.network "private_network", ip: "192.168.192.10", netmask: "255.255.255.0",
      virtualbox__intnet: "mgmt"
    vps1.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "512"
      vb.name = "vps1"
    end
    vps1.vm.provision "shell", inline: <<-SHELL
		route delete default
		echo "10.0.0.253" > /etc/mygate
		route add -inet 0/0 10.0.0.253
                echo 'net.inet.ip.forwarding=1' >> /etc/sysctl.conf
                sysctl -w net.inet.ip.forwarding=1
		sh -c "echo 'interface \\"em0\\" { ignore routers;}' >> /etc/dhclient.conf"
                ln -sf /usr/local/bin/python /usr/bin/python
    SHELL
    vps1.vm.provision "ansible" do |ansible|
      ansible.groups = ansible_groups
      ansible.playbook = "provisioning/playbook.yml"
    end
  end
  
=begin  
  config.vm.define "fw1", autostart: false do |fw1|
    fw1.vm.synced_folder ".", "/vagrant", disabled: true
    fw1.vm.hostname ="vps1"
    fw1.vm.box="trombik/ansible-openbsd-6.0-amd64"
    fw1.vm.box_check_update = false
    fw1.vm.network "private_network", ip: "172.31.3.254" , netmask: "255.255.255.0",
      virtualbox__intnet: "isp"
    fw1.vm.network "private_network", ip: "172.31.1.254", netmask: "255.255.255.0",
      virtualbox__intnet: "home"
    fw1.vm.network "private_network", ip: "172.31.5.254" , netmask: "255.255.255.0",
      virtualbox__intnet: "dmz"
    fw1.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "256"
      vb.name = "fw1"
    end
    vps1.vm.provision "shell", inline: <<-SHELL
                echo "172.31.3.251" > /etc/mygate
                route add -inet 0/0 172.31.3.251
                echo 'net.inet.ip.forwarding=1' >> /etc/sysctl.conf
                sysctl -w net.inet.ip.forwarding=1
                ln -sf /usr/local/bin/python /usr/bin/python
    SHELL
    vps1.vm.provision "ansible" do |ansible|
      ansible.groups = ansible_groups
      ansible.playbook = "provisioning/playbook.yml"
    end

  end 
  
  config.vm.define "vpnvps1" , autostart: false do |vpnvps1|
    ansible1.vm.synced_folder ".", "/vagrant", disabled: true
  # ...
  end 
  
  config.vm.define "client1" , autostart: false do |client1|
    ansible1.vm.synced_folder ".", "/vagrant", disabled: true
  # ...
  end

  config.vm.define "p2phost1" , autostart: false do |p2phost1|
    ansible1.vm.synced_folder ".", "/vagrant", disabled: true
  end   
=end

#end final
end

