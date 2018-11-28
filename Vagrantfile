# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'json'

appConfig = JSON.parse(File.read('config.json'))  # update config.<region>.json for each region
nodes = appConfig['nodes']

Vagrant.configure("2") do |config|

  nodes.each do |node|
    config.vm.define node['name'] do |config|
        envFile = '.env.' + node['name']
        f = File.new(envFile, 'w')
        f.write('OWNER_PRIVATE_KEY=' + node['ownerPrivateKey'] + "\n")
        f.write('COINBASE_PRIVATE_KEY=' + node['coinbasePrivateKey'] + "\n")
        f.write('COINBASE_ADDRESS=' + node['coinbaseAddress'] + "\n")
        f.close

        ENV['LC_ALL']="C.UTF-8"
        #ENV['DEBIAN_FRONTEND']='noninteractive'

        config.vm.provider :aws do |aws, override|
          aws.access_key_id = appConfig['accessKeyId']
          aws.secret_access_key = appConfig['secretAccessKey']
          aws.ami = node['ami']
          aws.region = node['region']
          aws.keypair_name = appConfig['sshKeyName']
          aws.instance_type = 't2.xlarge'
          aws.security_groups = [ 'vagrant' ]
          #aws.subnet_id = "subnet-a10e7ac5"
          aws.block_device_mapping = [
            { 
              'DeviceName' => '/dev/sda1', 
              'Ebs.VolumeSize' => 16 
              }
            ]
          aws.tags = {                                                                          
            'Name' => 'node-test',
          }
          override.vm.box = 'dummy'
          override.ssh.private_key_path = appConfig['privateKeyPath']
          override.ssh.username = 'ubuntu'
        config.vm.synced_folder ".", "/vagrant", disabled: true
        config.vm.provision "file", source: "./apply.sh", destination: "/home/ubuntu/apply.sh"
        config.vm.provision "file", source: envFile, destination: "/home/ubuntu/.env"
        $post_script = <<-SCRIPT
        sudo apt-get update
        sudo apt-get install \
                      apt-transport-https \
                      ca-certificates \
                      curl \
                      software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        sudo apt-get update && sudo apt-get install -y docker-ce
        sudo usermod -aG docker ubuntu
        sudo apt-get install -y python3 && sudo apt-get install -y python3-pip
        pip3 install --user tmn
        echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
        source /home/ubuntu/.env
        tmn start --name anonymous --pkey ${COINBASE_PRIVATE_KEY} --net testnet
        SCRIPT
        config.vm.provision "shell", inline: $post_script
        end
    end
  end
end