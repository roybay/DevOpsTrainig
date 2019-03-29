#!/bin/bash

CRT_FILE=nginx.hcmlab.com.crt
KEY_FILE=nginx.hcmlab.com.key
CERT_PW="Password1!"
OS=centos
RELEASE=7

WPA=web-agents-5.0.1.1-Apache_v24_Linux_64bit.zip
WPA_HOME=/opt/web_agents/apache24_agent
OPENAM_URL="http://monitoring.hcmlab.com:8080/am"
AGENT_URL="https://nginx.hcmlab.com:443"
AGENT_CONF="/etc/apache2/apache2.conf"
REALM=/Monitoring
WEB_AGENT_NAME=webagent
WEB_AGENT_PW="Password1"

#export LD_LIBRARY_PATH=/usr/lib64
#export LD_LIBRARY_PATH_64=/usr/lib64

#Install utility tools
sudo apt-get -y install wget zip unzip

#Install Apache 2.4
#by  https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/
sudo apt-get -y update
sudo apt-get -y install apache2

# Run apache as non root user
sudo setcap 'cap_net_bind_service=+ep' /usr/sbin/apache2
sudo /etc/init.d/apache2 stop
sudo chown -R www-data: /var/{log,run}/apache2/

#Add SSL Cert for this project
sudo mkdir /etc/ssl/apache2
sudo mv $CRT_FILE /etc/ssl/apache2/.
sudo mv $KEY_FILE /etc/ssl/apache2/.
sudo chown -R www-data: /etc/ssl/apache2

sudo -u www-data apache2ctl start

sudo rm /var/www/html/index.html
sudo a2enmod headers proxy proxy_http ssl proxy_wstunnel rewrite
sudo a2dissite 000-default.conf
sudo mv 001-* /etc/apache2/sites-available/.
sudo chown -R www-data: /etc/apache2

sudo a2ensite 001-monitoring.conf
sudo a2ensite 001-monitoring-ssl.conf
sudo sed -i 's/Indexes\ FollowSymLinks/FollowSymLinks/g' /etc/apache2/apache2.conf
sudo -u www-data apache2ctl restart
# sudo service apache2 restart


echo $WEB_AGENT_PW > .pw.txt
cd /opt
sudo unzip ~/$WPA
sudo mv ~/.pw.txt $WPA_HOME/bin/.
sudo chmod 400 $WPA_HOME/bin/.pw.txt
sudo chown -R www-data: /opt/web_agents
sudo -u www-data $WPA_HOME/bin/agentadmin --s $AGENT_CONF $OPENAM_URL $AGENT_URL $REALM $WEB_AGENT_NAME $WPA_HOME/bin/.pw.txt --changeOwner --acceptLicence

sudo -u www-data apache2ctl restart


