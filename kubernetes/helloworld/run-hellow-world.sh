#!/bin/bash

# Create Namespace
kubectl apply -f hw-namespace.yaml

# Deploy Hello Worlds Application
kubectl apply -f hw-deployment.yaml

# Deploy Hello Wrold LoadBalancer Service 
kubectl apply -f hw-service.yaml

# Deploy Hello World with Ingress Controller

## Ingress-nginx
cd ../ingress
./run-ingress-nginx-minikube.sh

cd ../helloworld 
kubectl apply -f hw-ingress.yaml