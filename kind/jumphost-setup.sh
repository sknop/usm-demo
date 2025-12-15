#!/bin/bash

# Set hostname to ensure we know we are on the right machine
sudo hostnamectl set-hostname usm-jumphost

# Install required software - docker
sudo apt update
sudo apt install docker.io
sudo usermod -G docker ubuntu

# Install kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-amd64
chmod +x kind && sudo mv kind /usr/local/bin

# Install helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 | bash

#
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && sudo mv kubectl /usr/local/bin

sudo git clone https://github.com/ahmetb/kubectx /usr/local/kubectx
sudo ln -s /usr/local/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /usr/local/kubectx/kubens /usr/local/bin/kubens

echo "Log out of your jump host and log back in again to complete the setup"

