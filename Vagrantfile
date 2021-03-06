# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.username = "vagrant"
  config.ssh.insert_key = true
  config.vm.box = "kalilinux/rolling"
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/vagrant"
  config.vm.provider "virtualbox" do |vb|
    # vb.gui = false
    vb.cpus = 4
    vb.memory = "4096"
    # vb.customize ["modifyvm", :id, "--vram", "256"]
  end
  config.vm.provision "shell", inline: <<-SHELL
    # quiet login 
    echo '' > /etc/motd
    sudo -u vagrant touch /home/vagrant/.hushlogin
    # install antibody
    curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
    # update dotfiles
    sudo -u vagrant sh -c "find /vagrant/dotfiles -type f | xargs -I {} ln -sf {} ~"
  SHELL
end
