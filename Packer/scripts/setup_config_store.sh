#!/bin/bash

RED='\033[1;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

#This code runs in VM part of the packer build
SERVICE_USER=opendj
SERVICE_GROUP=forgerock
ZIP_FILE=cfg.zip
OPENDJ_HOME=/opt/opendj/
FILE_HOME=/opt/bits

cd ${FILE_HOME}
sudo apt-get update 
sudo unzip /home/ubuntu/${ZIP_FILE}
sudo chown ${SERVICE_USER}:${SERVICE_GROUP} -R ${FILE_HOME}
#sudo rm /home/ubuntu/${ZIP_FILE}

sudo su opendj
cd ${FILE_HOME}cfg/Artifacts
./setup_opendj.sh

echo "Config Store Configured!"