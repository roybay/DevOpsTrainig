#!/bin/bash

CRT_FILE=nginx.hcmlab.com.crt
KEY_FILE=nginx.hcmlab.com.key
CERT_PW="Password1!"
OS=centos
RELEASE=7

WPA=web-agents-5.0.1.1-NGINX_r12_Centos7_64bit.zip
WPA_HOME=/home/rbahian/web_agents/nginx12_agent
OPENAM_URL="http://openam.ghcmlab.net:8080/am"
NGINX_URL="https://nginx.hcmlab.com:443"
NGINX_CONF="/etc/nginx/nginx.conf"
REALM=/
WEB_AGENT_NAME=nginx
WEB_AGENT_PW="Password1"

#export LD_LIBRARY_PATH=/usr/lib64
export LD_LIBRARY_PATH_64=/usr/lib64

#Install utility tools
sudo yum -y install wget zip unzip

#Install Nginx
#by  https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/
#FROM an OS Repository
#sudo yum -y install epel-release
#sudo yum -y update
#sudo yum -y install nginx

#FROM an NGINX Repository
sudo echo  "[nginx]" >> /etc/yum.repos.d/nginx.repo
sudo echo  "name=nginx repo" >> /etc/yum.repos.d/nginx.repo
sudo echo  "baseurl=https://nginx.org/packages/mainline/$OS/$RELEASE/$basearch" >> /etc/yum.repos.d/nginx.repo
sudo echo  "gpgcheck=0" >> /etc/yum.repos.d/nginx.repo
sudo echo  "enabled=1" >> /etc/yum.repos.d/nginx.repo

sudo yum -y update
sudo yum -y install nginx

#Add SSL Cert for this project
sudo mkdir /etc/nginx/cert
sudo cp $CRT_FILE /etc/nginx/cert/.
sudo cp $KEY_FILE /etc/nginx/cert/.
echo $CERT_PW > .pw.txt
sudo mv .pw.txt /etc/nginx/cert/.
sudo chmod 400 /etc/nginx/cert/.pw.txt

sudo cp monitoring.conf /etc/nginx/conf.d/.
sudo kill -QUIT $(cat /run/nginx.pid)
sudo nginx


unzip $WPA
echo $WEB_AGENT_PW > .pw.txt
mv .pw.txt $WPA_HOME/bin/.
sudo chmod 400 $WPA_HOME/bin/.pw.txt
sudo $WPA_HOME/bin/agentadmin --s $NGINX_CONF $OPENAM_URL $NGINX_URL $REALM $WEB_AGENT_NAME $WPA_HOME/bin/.pw.txt --acceptLicence

sudo kill -QUIT $(cat /run/nginx.pid)
sudo nginx


