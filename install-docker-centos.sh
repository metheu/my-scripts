#!/usr/bin/env bash


set -xe

sudo yum install -y epel-release &&
sudo yum install -y yum-utils device-mapper-persistent-data lvm2 &&
sudo yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo &&
sudo yum install docker-ce docker-ce-cli containerd.io &&
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
sudo chmod +x /usr/local/bin/docker-compose &&
sudo systemctl enable docker &&
sudo usermod -aG docker $USER &&
sudo systemctl start docker


