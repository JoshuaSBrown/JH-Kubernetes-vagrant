# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|


  # Step 1 Turn on the gui so we can interact with kibani
  #        set the memory to 1gb as per recommended for Kubernetes
  #config.vm.provider 'virtualbox' do |v|
  #  v.gui = true
  #  v.memory = 1024
  #  v.cpus = 1
  #end

  # Step 2 turn ssh on 
  config.ssh.forward_agent = true
  config.ssh.forward_x11   = true

  # Configure the Jupyterhub server node
  config.vm.define "jupyter" do | jupyter |
    jupyter.vm.provider 'virtualbox' do |v|
      v.gui = true
      v.memory = 1024
      v.cpus = 1
    end
    
    jupyter.vm.box = "centos/7"

    jupyter.vm.hostname = "jupyterhub"

    jupyter.vm.network "private_network", ip: "192.168.1.10"

    jupyter.vm.synced_folder ".", "/vagrant", id: "applicaiton", :nfs => true

    # Allow access to jupyterhub
    jupyter.vm.network "forwarded_port", guest: 8000, host: 8000
    jupyter.vm.network "forwarded_port", guest: 8081, host: 8081
    jupyter.vm.network "forwarded_port", guest: 5432, host: 5432

    # Step 9a ensure ansible is installed on the guest
    jupyter.vm.provision "shell", inline: "yum -y install epel-release && yum repolist && yum -y install ansible xorg-x11-xauth"

    # Step 10a provision 
    jupyter.vm.provision "guest_ansible" do |guest_ansible|
      guest_ansible.playbook = "JH-Kubernetes-playbook/jupyter.yml"
      guest_ansible.sudo = true
    end 

  end

  # Configure the main Kubernetes server/master node
  config.vm.define "master" do |master|
 
    master.vm.provider 'virtualbox' do |v|
      v.gui = true
      v.memory = 1024
      v.cpus = 1
    end
 
    # Step 3a configure os
    master.vm.box = "centos/7"
    
    # Step 4a Define host name
    master.vm.hostname = "JH-Kubernetes-master"

    # Step 5a configure network
    master.vm.network "private_network", ip: "192.168.1.11"

    # Step 6a allow host to be able to access guest notebook on port 8001
#    master.vm.network "forwarded_port", guest: 8000, host: 8000

    # Allows communication with the http proxy server
    #master.vm.network "forwarded_port", guest: 8001, host: 8001

#    master.vm.network "forwarded_port", guest: 8888, host: 8888

    # Step 7a allow host to access kubernetes dashboard on port 8080
    # Allows communication with the http proxy server
    master.vm.network "forwarded_port", guest: 8080, host: 8080

#    master.vm.network "forwarded_port", guest: 2379, host: 2379

    # Step 8a to get rid of rsync error
    master.vm.synced_folder ".", "/vagrant", id: "applicaiton", :nfs => true

    # Step 9a ensure ansible is installed on the guest
    master.vm.provision "shell", inline: "yum -y install epel-release && yum repolist && yum -y install ansible xorg-x11-xauth"

    # Step 10a provision 
    master.vm.provision "guest_ansible" do |guest_ansible|
      guest_ansible.playbook = "JH-Kubernetes-playbook/master.yml"
      guest_ansible.sudo = true
    end 
  end

  # Create the rest of the cluster/client nodes
  (1..1).each do |i| 
    config.vm.define "minion-#{i}" do |minion|

     # Step 3a configure os
      minion.vm.box = "centos/7"

      # Step 4b Define host name
      minion.vm.hostname = "JH-Kubernetes-minion-#{i}"

      # Step 5b configure network
      minion.vm.network "private_network", ip: "192.168.1.1#{1+i}"

      # Step 6b to get rid of rsync error
      minion.vm.synced_folder ".", "/vagrant", id: "applicaiton", :nfs => true

      # Step 7b ensure ansible is installed on the guest
      minion.vm.provision "shell", inline: "yum -y install epel-release && yum repolist && yum -y install ansible xorg-x11-xauth"

      # Step 8b provision 
      minion.vm.provision "guest_ansible" do |guest_ansible|
        guest_ansible.playbook = "JH-Kubernetes-playbook/minion.yml"
        guest_ansible.sudo = true
      end 
    end
  end
end
