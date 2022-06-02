Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vm|
    vm.memory = 2048
    vm.cpus = 4
  end

  config.vm.box = "hk-ubuntu"
  config.vm.box_url = "https://f99887ee-65bc-46ea-be13-64517d761b27.s3.ap-southeast-1.amazonaws.com/talent-test-ubuntu-v1.box"
  config.vm.box_download_checksum = "74033f0cfd1240deea5e6def5ec0e70dafe1a0b4"
  config.vm.box_download_checksum_type = "sha1"


  config.vm.synced_folder ".",
                          "/home/vagrant/app",
                          automount: true

  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 3035, host: 3035

  config.vm.provision "shell", path: "./vagrant/provision.sh"
end
