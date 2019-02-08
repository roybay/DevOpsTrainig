#!/bin/bash

# Create Namespace
kubectl apply -f ds_cfg_store_namespace.yaml

# Create cfg-store deployment
kubectl apply -f ds_cfg_store_deployment.yaml

# Secrets
#kubectl apply -f openam-runtime-secrets.yaml
#kubectl create secret tls openam-ingress-cert --cert=$AMCERT --key=$AMCERTKEY -n $NAMESPACE

# Deploy AM
#kubectl apply -f openam-deployment.yaml

# Deploy AM_Service
#kubectl apply -f openam-service.yaml

# Deploy Ingress Controller
#kubectl apply -f openam-ingress-ssl.yaml