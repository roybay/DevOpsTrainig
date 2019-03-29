#!/bin/bash
. ./prometheus.properties

yum -y install wget zip unzip

#export LD_LIBRARY_PATH=/usr/lib64
export LD_LIBRARY_PATH_64=/usr/lib64

#FROM an NGINX Repository
echo  "[nginx]" >> /etc/yum.repos.d/nginx.repo
echo  "name=nginx repo" >> /etc/yum.repos.d/nginx.repo
echo  "baseurl=https://nginx.org/packages/mainline/$OS/$RELEASE/\$basearch" >> /etc/yum.repos.d/nginx.repo
echo  "gpgcheck=0" >> /etc/yum.repos.d/nginx.repo
echo  "enabled=1" >> /etc/yum.repos.d/nginx.repo

yum -y update
yum -y install nginx

#Add SSL Cert for this project
mkdir /etc/nginx/cert
cp $SSL_CRT /etc/nginx/cert/.
cp $SSL_KEY /etc/nginx/cert/.


sed -i -e 's,SSL_CRT,'$SSL_CRT',g' nginx_prometheus.conf
sed -i -e 's,SSL_KEY,'$SSL_KEY',g' nginx_prometheus.conf

cp nginx_prometheus.conf /etc/nginx/conf.d/.
kill -QUIT $(cat /run/nginx.pid)
nginx

# Prometheus 
wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
tar -xzvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
INSDIR=prometheus-${PROMETHEUS_VERSION}.linux-amd64
# if you just want to start prometheus as root
#./prometheus --config.file=prometheus.yml

# create user
useradd --no-create-home --shell /bin/false prometheus

# create directories
mkdir -p /etc/prometheus
mkdir -p /var/lib/prometheus

# set ownership
chown prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus

# copy binaries
cp $INSDIR/prometheus /usr/local/bin/
cp $INSDIR/promtool /usr/local/bin/

chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool

# copy config
cp -r $INSDIR/consoles /etc/prometheus
cp -r $INSDIR/console_libraries /etc/prometheus
rm -f /etc/prometheus/prometheus.yml
cp -r prometheus.yaml /etc/prometheus/prometheus.yaml

chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries

# setup systemd
echo '[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file=/etc/prometheus/prometheus.yaml \
    --storage.tsdb.path=/var/lib/prometheus/ \
    --web.route-prefix=/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries \
    --web.external-url=http://monitor:9090


[Install]
WantedBy=multi-user.target' > /etc/systemd/system/prometheus.service

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus



