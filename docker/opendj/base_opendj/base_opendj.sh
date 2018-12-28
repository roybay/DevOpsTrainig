#!/bin/bash

. ../../docker_registry.sh

build_base_image(){
	cp ../../../bits/DS-6.0.0.zip .
	docker build --tag molpis/opendj_base:6.0.0 --file ./base.Dockerfile . 
	docker_base_image
	rm ./DS-6.0.0.zip
}

build_base_image

