# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2304"

#---------- arc310 ----------
  config.vm.define "arc310_192.168.33.120" do |server|
    server.vm.network "private_network", ip: "192.168.33.120"
    server.vm.hostname = "arc310"
    server.vm.provider "libvirt" do |kvm|
      kvm.storage_pool_name = "data"
      kvm.memory = 24576
      kvm.cpus = 4
      kvm.storage_pool_name = "data"
      kvm.machine_type = "q35"
      kvm.cpu_mode = "host-passthrough"
      kvm.kvm_hidden = true
      kvm.pci :bus => '0x03', :slot => '0x00', :function => '0x0'
    end
    server.vm.provision "shell", inline: <<-SHELL
      sudo update-initramfs -u 
      sudo apt-get update
      sudo apt-get install -y curl
      sudo apt-get install -y docker.io
      sudo systemctl enable docker
    SHELL
  end
#--------------------
end
