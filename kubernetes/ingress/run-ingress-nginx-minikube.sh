#!/bin/bash

# Disable default ingress
minikube addons enable ingress

# Deploy ingress-nginx 
kubectl apply -f mandatory.yaml

