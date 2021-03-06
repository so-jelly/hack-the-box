# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.username = "vagrant"
  config.ssh.insert_key = true
  config.vm.box = "kalilinux/rolling"
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "tmp/", "/home/vagrant/tmp", owner: "vagrant"
  config.vm.synced_folder "dotfiles/", "/home/vagrant/dotfiles", owner: "vagrant"
  config.vm.provider "virtualbox" do |vb|
    # vb.gui = false
    vb.cpus = 4
    vb.memory = "4096"
    # vb.customize ["modifyvm", :id, "--vram", "256"]
  end
  config.vm.provision "shell", inline: <<-SHELL
    echo '' > /etc/motd
    curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
    sudo -u vagrant touch /home/vagrant/.hushlogin
    sudo -u vagrant ln -sf dotfiles/.zshrc dotfiles/.zsh_plugins.txt ./
  SHELL
end
