# -- mode: ruby --
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "node1" do |node1|
    node1.vm.box = "ubuntu/jammy64"
    node1.vm.hostname = "node-cp1"
    node1.vm.network "public_network", bridge: "wlp4s0", ip: "192.168.1.20"
    node1.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
  end

  # config.vm.define "node2" do |node2|
  #   node2.vm.box = "ubuntu/jammy64"
  #   node2.vm.hostname = "node-cp2"
  #   node2.vm.network "public_network", bridge: "wlp4s0", ip: "192.168.1.21"
  #   node2.vm.provider "virtualbox" do |vb|
  #     vb.memory = "2048"
  #     vb.cpus = 2
  #   end
  # end

  # config.vm.define "node3" do |node3|
  #   node3.vm.box = "ubuntu/jammy64"
  #   node3.vm.hostname = "node-cp3"
  #   node3.vm.network "public_network", bridge: "wlp4s0", ip: "192.168.1.22"
  #   node3.vm.provider "virtualbox" do |vb|
  #     vb.memory = "2048"
  #     vb.cpus = 2
  #   end
  # end

  config.vm.define "node4" do |node4|
    node4.vm.box = "ubuntu/jammy64"
    node4.vm.hostname = "node-worker1"
    node4.vm.network "public_network", bridge: "wlp4s0", ip: "192.168.1.30"
    node4.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
  end

  config.vm.define "node5" do |node5|
    node5.vm.box = "ubuntu/jammy64"
    node5.vm.hostname = "node-worker2"
    node5.vm.network "public_network", bridge: "wlp4s0", ip: "192.168.1.31"
    node5.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
    end
  end

  # config.vm.define "db" do |db|
  #   db.vm.box = "ubuntu/jammy64"
  #   db.vm.hostname = "db"
  #   db.vm.network "public_network", bridge: "wlp4s0", ip: "192.168.1.40"
  #   db.vm.provider "virtualbox" do |vb|
  #     vb.memory = "512"
  #     vb.cpus = 1
  #   end
  # end

  # config.vm.define "lb1" do |lb1|
  #   lb1.vm.box = "ubuntu/jammy64"
  #   lb1.vm.hostname = "lb1"
  #   lb1.vm.network "public_network", bridge: "wlp4s0", ip: "192.168.1.50"
  #   lb1.vm.provider "virtualbox" do |vb|
  #     vb.memory = "512"
  #     vb.cpus = 1
  #   end
  # end

  # config.vm.define "lb2" do |lb2|
  #   lb2.vm.box = "ubuntu/jammy64"
  #   lb2.vm.hostname = "lb2"
  #   lb2.vm.network "public_network", bridge: "wlp4s0", ip: "192.168.1.51"
  #   lb2.vm.provider "virtualbox" do |vb|
  #     vb.memory = "512"
  #     vb.cpus = 1
  #   end
  # end

  config.vm.provision "shell" do |s|
     key = Dir::home() + "/.ssh/id_rsa.pub"
     ssh_pub_key = File.readlines(key).first.strip
     s.inline = <<-SHELL
     echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
     echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
     SHELL
  end

  config.vm.provision "shell", run: "always", inline: <<-SHELL
    sudo ip route delete default
    sudo ip route add default via 192.168.1.254
    SHELL


  config.vm.provision "shell", inline: <<-SHELL
  echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
  echo "192.168.1.30 node1.local" | sudo tee -a /etc/hosts
  echo "192.168.1.31 node2.local" | sudo tee -a /etc/hosts
  echo "192.168.1.20 cp1.local" | sudo tee -a /etc/hosts
  echo "192.168.1.21 cp2.local" | sudo tee -a /etc/hosts
  echo "192.168.1.22 cp3.local" | sudo tee -a /etc/hosts
  echo "192.168.1.40 db.local" | sudo tee -a /etc/hosts
  echo "192.168.1.50 lb1.local" | sudo tee -a /etc/hosts
  echo "192.168.1.51 lb2.local" | sudo tee -a /etc/hosts
  echo "192.168.1.52 cp.local" | sudo tee -a /etc/hosts
  SHELL

    # Ansible playbook provisioning
    config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "1.8"
    ansible.playbook = "ansible/playbooks/common.yaml"
  end
end
