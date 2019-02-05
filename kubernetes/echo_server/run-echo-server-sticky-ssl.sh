#!/bin/bash

# Create Namespace
kubectl apply -f echo-namespace.yaml

# Deploy Echo Server Application
kubectl apply -f echo-deployment.yaml

# Deploy Echo Server ClusterIP Service 
kubectl apply -f echo-service.yaml

# Deploy Echo Server with Ingress Controller

## Ingress-nginx
cd ../ingress
./run-ingress-nginx-minikube.sh

cd ../echo_server 

if [ ! -f echo-tls.key ] ; then
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./echo-tls.key -out ./echo-tls.crt -subj "/CN=echo.roylab.com"
	kubectl create secret tls echo-cert --cert=./echo-tls.crt --key=./echo-tls.key -n echo
fi

kubectl apply -f echo-ingress-sticky-ssl.yaml