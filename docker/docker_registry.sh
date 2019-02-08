#!/bin/bash

USERNAME=roybay04
PASSWORD=$(<../../.pw)

docker_login(){
	docker login --username $USERNAME --password $PASSWORD
}

docker_logout(){
	docker logout
}

docker_push(){
	docker push molpis/$1
}

docker_base_image(){
	docker_login
	docker_push opendj_base:6.0.0
	docker_logout
}

docker_cfg_store_image(){
	docker_login
	docker_push opendj_cfg_store:6.0.0
	docker_logout
}

docker_cts_store_image(){
	docker_login
	docker_push opendj_cts_store:6.0.0
	docker_logout
}

docker_usr_store_image(){
	docker_login
	docker_push opendj_usr_store:6.0.0
	docker_logout
}