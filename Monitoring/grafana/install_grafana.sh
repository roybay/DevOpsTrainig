#!/bin/bash

. ./grafana.properties 

yum -y update
yum -y install wget zip unzip

wget https://dl.grafana.com/oss/release/grafana-6.0.2-1.x86_64.rpm 
yum -y localinstall grafana-6.0.2-1.x86_64.rpm

cp ./grafana.ini $GRAFANA_HOME/.
cp -r  provisioning $GRAFANA_HOME/. -u

#Add SSL Cert for this project
mkdir $GRAFANA_HOME/cert
cp $SSL_CRT $GRAFANA_HOME/cert/.
cp $SSL_KEY $GRAFANA_HOME/cert/.

# DATASOURCES
sed -i -e 's,PROMETHEUS,'$PROMETHEUS',g' $GRAFANA_HOME/provisioning/datasources/datatsource_prometheus.yaml

# DASHBOARDS
find $GRAFANA_HOME/provisioning/dashboards/ -type f -exec sed -i -e 's,DS_PROMETHEUS,'ForgeRock',g' {} \;
find $GRAFANA_HOME/provisioning/dashboards/ -type f -exec sed -i -e 's,DS_FORGEROCKDS,'ForgeRock',g' {} \;
find $GRAFANA_HOME/provisioning/dashboards/ -type f -exec sed -i -e 's,'\$\{ForgeRock\}','ForgeRock',g' {} \;


# SERVER
sed -i -e 's,PROXY_URL,'$PROXY_URL',g' $GRAFANA_HOME/grafana.ini
sed -i -e 's,SSL_CRT,'$GRAFANA_HOME/cert/$SSL_CRT',g' $GRAFANA_HOME/grafana.ini
sed -i -e 's,SSL_KEY,'$GRAFANA_HOME/cert/$SSL_KEY',g' $GRAFANA_HOME/grafana.ini

# SECURITY
sed -i -e 's,ADMIN_USERNAME,'$ADMIN_USERNAME',g' $GRAFANA_HOME/grafana.ini
sed -i -e 's,ADMIN_PASSWORD,'$ADMIN_PASSWORD',g' $GRAFANA_HOME/grafana.ini

# OAUTH2
sed -i -e 's,CLIENT_ID,'$CLIENT_ID',g' $GRAFANA_HOME/grafana.ini
sed -i -e 's,CLIENT_SECRET,'$CLIENT_SECRET',g' $GRAFANA_HOME/grafana.ini
sed -i -e 's,AM_AUTH_URL,'$AM_AUTH_URL',g' $GRAFANA_HOME/grafana.ini
sed -i -e 's,AM_TOKEN_URL,'$AM_TOKEN_URL',g' $GRAFANA_HOME/grafana.ini
sed -i -e 's,AM_USERINFO,'$AM_USERINFO',g' $GRAFANA_HOME/grafana.ini


systemctl daemon-reload
systemctl start grafana-server
systemctl enable grafana-server.service

# /usr/share/grafana/conf/defaults.ini
# /etc/grafana/grafana.ini
# /var/log/grafana'