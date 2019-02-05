#!/bin/bash

# Delete ingress-nginx ns 
kubectl delete ns ingress-nginx

# Enable default ingress
minikube addons disable ingress


