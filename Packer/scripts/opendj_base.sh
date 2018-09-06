#!/bin/bash

RED='\033[1;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

#This code runs in VM part of the packer build
SERVICE_USER=opendj
SERVICE_GROUP=forgerock
SERVICE_UID=11111
OPENDJ_ZIP=DS-6.0.0.zip
OPENDJ_HOME=/opt/opendj
FILE_HOME=/opt/bits

sudo apt-get update 
sudo groupadd -g ${SERVICE_UID} ${SERVICE_GROUP}
sudo useradd  -s /bin/bash -u ${SERVICE_UID} -U ${SERVICE_USER} -G ${SERVICE_GROUP} -d ${OPENDJ_HOME}
cd /opt
sudo mkdir bits 
sudo unzip /home/ubuntu/${OPENDJ_ZIP}  
sudo rm /home/ubuntu/${OPENDJ_ZIP}
sudo chown ${SERVICE_USER}:${SERVICE_GROUP} -R ${SERVICE_USER}
sudo chown ${SERVICE_USER}:${SERVICE_GROUP} -R ${FILE_HOME}
sudo apt-get update

echo "OpenDJ ready to configure!"