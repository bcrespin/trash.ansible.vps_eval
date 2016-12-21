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
   "home_clients" => [
        "client1",
        "client2",
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
    router1.vm.provision "shell",run: "always", inline: <<-SHELL
                route delete default
                echo "10.0.0.252" > /etc/mygate
                route add -inet 0/0 10.0.0.252
		echo 'net.inet.ip.forwarding=1' >> /etc/sysctl.conf
                sysctl -w net.inet.ip.forwarding=1

                sh -c "echo 'interface \\"em0\\" { ignore routers,domain-name-servers;}' >> /etc/dhclient.conf"
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
    vps1.vm.provision "shell",run: "always", inline: <<-SHELL
		route delete default
		route add -inet 172.31.3.0/24 10.0.0.251
		route add -inet 0/0 10.0.0.253
                echo 'net.inet.ip.forwarding=1' >> /etc/sysctl.conf
                sysctl -w net.inet.ip.forwarding=1
		sh -c "echo 'interface \\"em0\\" { ignore routers,domain-name-servers;}' >> /etc/dhclient.conf"
                ln -sf /usr/local/bin/python /usr/bin/python
    SHELL
    vps1.vm.provision "ansible" do |ansible|
      ansible.groups = ansible_groups
      ansible.playbook = "provisioning/playbook.yml"
    end
  end
  
  config.vm.define "fw1", autostart: true do |fw1|
    fw1.vm.synced_folder ".", "/vagrant", disabled: true
    fw1.vm.hostname ="fw1"
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
    fw1.vm.provision "shell",run: "always", inline: <<-SHELL
                route delete default
                echo "172.31.3.251" > /etc/mygate
                route add -inet 0/0 172.31.3.251
                echo 'net.inet.ip.forwarding=1' >> /etc/sysctl.conf
                sysctl -w net.inet.ip.forwarding=1
                ln -sf /usr/local/bin/python /usr/bin/python

    SHELL
    fw1.vm.provision "ansible" do |ansible|
      ansible.groups = ansible_groups
      ansible.playbook = "provisioning/playbook.yml"
    end

  end

  config.vm.define "client1", autostart: true do |client1|
    client1.vm.synced_folder ".", "/vagrant", disabled: true
    client1.vm.hostname ="client1"
    client1.vm.box="trombik/ansible-openbsd-6.0-amd64"
    client1.vm.box_check_update = false
    client1.vm.network "private_network", ip: "172.31.1.10", netmask: "255.255.255.0",
      virtualbox__intnet: "home"

    client1.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "256"
      vb.name = "client1"
    end
    client1.vm.provision "shell", run: "always",inline: <<-SHELL
                route delete default
                echo "172.31.1.254" > /etc/mygate
                route add -inet 0/0 172.31.1.254
                sh -c "echo 'interface \\"em0\\" { ignore routers,domain-name-servers;}' >> /etc/dhclient.conf"
                ln -sf /usr/local/bin/python /usr/bin/python
    SHELL
    client1.vm.provision "ansible" do |ansible|
      ansible.groups = ansible_groups
      ansible.playbook = "provisioning/playbook.yml"
    end

  end

  config.vm.define "client2", autostart: true do |client2|
    client2.vm.synced_folder ".", "/vagrant", disabled: true
    client2.vm.hostname ="client2"
    client2.vm.box="trombik/ansible-openbsd-6.0-amd64"
    client2.vm.box_check_update = false
    client2.vm.network "private_network", ip: "172.31.1.20", netmask: "255.255.255.0",
      virtualbox__intnet: "home"

    client2.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "256"
      vb.name = "client2"
    end
    client2.vm.provision "shell",run: "always", inline: <<-SHELL
                route delete default
                echo "172.31.1.254" > /etc/mygate
                route add -inet 0/0 172.31.1.254
                sh -c "echo 'interface \\"em0\\" { ignore routers,domain-name-servers;}' >> /etc/dhclient.conf"
                ln -sf /usr/local/bin/python /usr/bin/python
    SHELL
    client2.vm.provision "ansible" do |ansible|
      ansible.groups = ansible_groups
      ansible.playbook = "provisioning/playbook.yml"
    end
  end

  config.vm.define "vpnvps1", autostart: true do |vpnvps1|
    vpnvps1.vm.synced_folder ".", "/vagrant", disabled: true
    vpnvps1.vm.hostname ="vpnvps1"
    vpnvps1.vm.box="trombik/ansible-openbsd-6.0-amd64"
    vpnvps1.vm.box_check_update = false
    vpnvps1.vm.network "private_network", ip: "172.31.5.100", netmask: "255.255.255.0",
      virtualbox__intnet: "dmz"

    vpnvps1.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "256"
      vb.name = "vpnvps1"
    end
    vpnvps1.vm.provision "shell", inline: <<-SHELL
                route delete default
                echo "172.31.5.254" > /etc/mygate
                route add -inet 0/0 172.31.5.254
                sh -c "echo 'interface \\"em0\\" { ignore routers,domain-name-servers;}' >> /etc/dhclient.conf"
                ln -sf /usr/local/bin/python /usr/bin/python
    SHELL
    vpnvps1.vm.provision "ansible" do |ansible|
      ansible.groups = ansible_groups
      ansible.playbook = "provisioning/playbook.yml"
    end
  end


#end final
end

