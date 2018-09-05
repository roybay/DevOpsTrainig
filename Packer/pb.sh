#!/bin/bash

FILE="./OpenDJ.json"

packer_build(){
	cp ../bits/DS-6.0.0.zip .
	packer build -force ${FILE}
	rm DS-6.0.0.zip 
}

packer_build