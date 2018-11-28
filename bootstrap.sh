#!/bin/bash

source /home/ubuntu/.env
sudo apt-get update
sudo apt-get install -y \
                apt-transport-https \
                ca-certificates \
                software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update && sudo apt-get install -y docker-ce
sudo usermod -aG docker ubuntu
sudo apt-get install -y python3 && sudo apt-get install -y python3-pip
pip3 install tmn
echo 'export PATH=\$PATH:~/.local/bin' >> ~/.bashrc
tmn start --name haidv --pkey ${COINBASE_PRIVATE_KEY} --net testnet