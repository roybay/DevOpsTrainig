#!/bin/bash

RED='\033[1;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
ANSIBLE_TARGET_VERSION="ansible 2.6.3"

#This code runs in VM part of the packer build
sudo apt-get update 
sudo apt-get -y install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get -y install zip 
sudo apt-get update

echo "${GREEN}Installing ansible dependencies{NC}"
sudo apt-get -y install ansible

echo "Checking ansible version!"

ANSIBLE_VERSION=$(ansible --version | head -1)

echo "ANSIBLE_VERSION        : ${ANSIBLE_VERSION}"
echo "ANSIBLE_TARGET_VERSION : ${ANSIBLE_TARGET_VERSION}"

if [ "${ANSIBLE_VERSION}" !== "${ANSIBLE_TARGET_VERSION}" ] 
then
	echo "\n{RED}Installed ansible version is not expected!${NC}"
	exit 1
fi