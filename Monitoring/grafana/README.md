Grafana References 
==================

Grafana Documentation: 
http://docs.grafana.org/

Grafana Donwload: 
https://grafana.com/grafana/download

Grafana Variables: 
/etc/sysconfig/grafana-server

How To Install Grafana
----------------------
1. Copy DevOpsTraining repo to prometheus box

1. Go to DevOpsTraining/node_exporter

1. Run install_node-exporter.sh for each VM that would like to have OS level monitoring

1. Go to DevOpsTraining/grafana

1. Add prometheus ssl cert and private ket in the same folder DevOpsTraining/grafana 

1. Modify grafana.properties file 

1. Run install_grafana.sh

How To Test Grafana:
--------------------

https://<grafana_domeain>:3000/