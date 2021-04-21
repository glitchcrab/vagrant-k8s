Vagrant.configure("2") do |config|
  config.vm.provision :shell,
    privileged: true,
    path: "scripts/01-common.sh"

  config.vm.define :master do |master|
    master.vm.provider :virtualbox do |vb|
      vb.name = "master"
      vb.memory = 2048
      vb.cpus = 2
    end
    master.vm.box = "ubuntu/bionic64"
    master.vm.disk :disk,
      size: "5GB",
      primary: true
    master.vm.hostname = "master"
    master.vm.network :private_network, ip: "10.0.0.10"
    master.vm.network "forwarded_port",
      guest: 6443,
      host: 6443,
      host_ip: "127.0.0.1"
    master.vm.provision :shell,
      privileged:
      false,
      path: "scripts/02-provision-master.sh"
  end

  %w{node1 node2 node3}.each_with_index do |name, i|
    config.vm.define name do |node|
      node.vm.provider "virtualbox" do |vb|
        vb.name = "node#{i + 1}"
        vb.memory = 2048
        vb.cpus = 2
      end
      node.vm.box = "ubuntu/bionic64"
      node.vm.disk :disk,
        size: "5GB",
        primary: true
      node.vm.disk :disk,
        size: "5GB",
        name: "extra_storage"
      node.vm.hostname = name
      node.vm.network :private_network, ip: "10.0.0.#{i + 11}"
      node.vm.provision "shell",
        privileged: false,
        args: [ name, "#{i + 11}" ],
        inline: "/bin/sh /vagrant/scripts/03-provision-worker.sh $1 $2"
    end
  end

  config.vm.provision "shell", path: "scripts/04-multicast.sh"
end
