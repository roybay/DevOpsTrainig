#!/bin/bash

# Delete Namespace
kubectl delete namespace hw

# Delete ingress-nginx 
cd ../ingress
./del-ingress-nginx-minikube.sh 

cd ../helloworld 