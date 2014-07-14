# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos-5.8-x86_64"
  # config.vm.box_url = "https://dl.dropboxusercontent.com/s/sij0m2qmn02a298/centos-5.8-x86_64.box"


  config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=777"]


  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "3048"]
    vb.customize ["modifyvm", :id, "--name", "db"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.provision :puppet do |puppet|
    puppet.module_path       = "puppet/modules"
    puppet.manifests_path    = "puppet/manifests"
    puppet.manifest_file     = "site.pp"
    # puppet.options           = "--verbose  --parser future"
    puppet.facter = {
      'environment' => 'obeheer1',
      'vm_type'     => 'vagrant'
    }
  end
end
