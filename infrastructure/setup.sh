#!/bin/bash

apt-get update
apt-get install -y curl wget

# Install terraform
apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt update
apt-get install -y terraform

# Install terragrunt
# TODO: make this work for intel chips too.

wget "https://github.com/gruntwork-io/terragrunt/releases/download/v0.53.0/terragrunt_linux_arm64" -O "terragrunt"
chmod u+x terragrunt
mv terragrunt /usr/local/bin/terragrunt


# Install AWS CLI

apt-get install -y unzip
# Depending on the architecture, download and install the appropriate AWS CLI version
curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "awscliv2.zip"

unzip awscliv2.zip
./aws/install

# Housecleaning
rm -r aws/
rm awscliv2.zip
