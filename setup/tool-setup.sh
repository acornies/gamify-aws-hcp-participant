#!/bin/bash

ARCH=$(uname -m)

# Install HashiCorp tools (Terraform and Vault)
sudo apt-get update
sudo apt-get install -y gnupg software-properties-common ca-certificates

apt-get install -y wget unzip jq

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt-get install -y terraform=1.5.3-1 vault=1.14.0-1

# Install AWS CLI
if [ $ARCH = "arm64" ]; then
    curl --silent https://awscli.amazonaws.com/awscli-exe-linux-arm64.zip \
        --output awscliv2.zip
else
    curl --silent https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
        --output awscliv2.zip
fi
unzip awscliv2.zip
sudo ./aws/install

rm -rf awscliv2.zip aws

# Install Vault Lambda Extension
if [ $ARCH = "arm64" ]; then
    curl --silent https://releases.hashicorp.com/vault-lambda-extension/0.10.1/vault-lambda-extension_0.10.1_linux_arm64.zip \
        --output vault-lambda-extension.zip
else
    curl --silent https://releases.hashicorp.com/vault-lambda-extension/0.10.1/vault-lambda-extension_0.10.1_linux_amd64.zip \
        --output vault-lambda-extension.zip
fi

unzip vault-lambda-extension.zip -d ./
rm -rf vault-lambda-extension.zip
