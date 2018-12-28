#!/bin/bash

ANSIBLE="./ansible-ubuntu-1804.json"
BASE="./opendj_base_image.json"
CFG_STORE="./opendj_config_store.json"

ansible_packer_build(){
	packer build -force ${ANSIBLE}
}

base_packer_build(){
	cp ../bits/DS-6.0.0.zip cp  .
	packer build -force ${BASE}
	rm DS-6.0.0.zip
}

cfg_store_packer_build(){
	cp -r ../docker/opendj/config_store/Artifacts .
	cp -r ../docker/opendj/scripts/* ./Artifacts/.
	zip -r Artifacts.zip ./Artifacts
	packer build -force ${CFG_STORE}
	rm -rf Artifacts Artifacts.zip
}

#ansible_packer_build
#base_packer_build
cfg_store_packer_build