NodeExporter References  
=======================

Prometheus Node Exporter Documentation: 
https://prometheus.io/docs/guides/node-exporter/

NodeExporter Donwload: 
https://prometheus.io/download/

NodeExporter GitHub:
https://github.com/prometheus/node_exporter

How To Install NodeExporter:
----------------------------
1. Copy DevOpsTraining repo to prometheus box

1. Go to DevOpsTraining/Monitoring/node_exporter

1. Run install_node-exporter.sh as root for each VM that would like to have OS level monitoring


How To Test NodeExporter:
-------------------------
curl http://$(hostname -f):9100/metrics






