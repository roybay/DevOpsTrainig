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
kubectl apply -f echo-ingress.yaml