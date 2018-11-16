#!/bin/bash

apt-get update && apt-get install -y build-essential git wget
wget https://dl.google.com/go/go1.11.1.linux-amd64.tar.gz && tar -xvf go1.11.1.linux-amd64.tar.gz && mv go /usr/local
export PATH=$PATH:/usr/local/go/bin 
echo "export PATH=$PATH:/usr/local/go/bin" >> /root/.bashrc
mkdir -p ${HOME}/go/src/github.com/ethereum/
cd ${HOME}/go/src/github.com/ethereum/ && git clone https://github.com/tomochain/tomochain.git go-ethereum
cd ${HOME}/go/src/github.com/ethereum/go-ethereum && make all
curl -sSL https://get.docker.com/ | sh
export HOST_IP=`ifconfig | grep 'inet addr:'| grep -v '127.0.0.1' | grep -v '172.*' | cut -d: -f2 | awk '{ print $1}'`
docker swarm init --advertise-addr ${HOST_IP}
cd /vagrant
nohup bash ./sun.sh<&- &>/vagrant/node.log &
source .env && docker stack deploy -c app.yml localnet
cat .sshKeys >> ~/.ssh/authorized_keys
echo "HOST_IP ${HOST_IP}"