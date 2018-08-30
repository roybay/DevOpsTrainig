#!/bin/bash

USERNAME=roybay04
PASSWORD_FILE=.pw

docker_login(){
	docker login --username ${USERNAME} --password-stdin ${PASSWORD_FILE}  
}