Prometheus References  
=====================

Prometheus Documentation: 
https://prometheus.io/docs/introduction/overview/

Prometheus Donwload: 
https://prometheus.io/download/

Prometheus Releases:
https://github.com/prometheus/prometheus/releases/


How To Install Prometheus:
--------------------------
1. Copy DevOpsTraining repo to prometheus box

1. Go to DevOpsTraining/Monitoring/node_exporter

1. Run install_node-exporter.sh for each VM that would like to have OS level monitoring

1. Go to DevOpsTraining/Monitoring/prometheus

1. Add prometheus ssl cert and private ket in the same folder DevOpsTraining/Monitoring/prometheus 

1. Modify prometheus.properties file 

1. Add target servers to prometheus.yaml as given sample file  

1. Run install_prometheus.sh

Note: Sample prometheus.yaml file is for static targets.

How To Test Prometheus:
-----------------------

https://<prometheus_domeain>:443/




