# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.username = "vagrant"
  config.ssh.insert_key = true
  config.vm.box = "kalilinux/rolling"
  config.vm.box_check_update = false
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "public_network"
  config.vm.synced_folder "kali", "/vagrant"
  config.vm.provider "virtualbox" do |vb|
    # vb.gui = false
    vb.cpus = 4
    vb.memory = "4096"
    # vb.customize ["modifyvm", :id, "--vram", "256"]
  end
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
