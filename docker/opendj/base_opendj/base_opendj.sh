#!/bin/bash

build_base_image(){
	docker build --tag opendj_base:6.0.0 --file base.Dockerfile . 
}