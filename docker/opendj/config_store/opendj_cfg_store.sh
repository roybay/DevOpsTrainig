#!/bin/bash

. ../../docker_registry.sh

build_cfg_store_image(){
	cp -r ../scripts .
	docker build --tag molpis/opendj_cfg_store:6.0.0 --file ./cfgStore.Dockerfile . 
	docker_cfg_store_image
	rm -rf scripts
}

build_cfg_store_image

