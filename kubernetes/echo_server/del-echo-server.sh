#!/bin/bash

# Delete Namespace
kubectl delete namespace echo

# Delete ingress-nginx 
cd ../ingress
./del-ingress-nginx-minikube.sh 

cd ../echo_server

if [ -f echo-tls.key ] ; then
    rm echo-tls.*
fi