README - Hello World!
=====================
./run-hello-world.sh

minikube ip 
will show ip address of minikibue.
Ex: 192.168.99.100

kubectl get svc -n hw

NAME         TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
hw-service   LoadBalancer   10.96.22.180   <pending>     80:31483/TCP   9m51s

It will not give external ip address once this is a minikube env. 
Thus, you need to use node ip address and nodeport shown abow. 

Below URL shows Hellow World application. 
http://192.168.99.100:31483

Once hw-ingess is deployed. 
it only accept request comming from specified hostname and path
hw.roylab.com
Thus, etc/hosts file need to be modifed 

192.168.99.100 hw.roylab.com

Than, we can use 
http://hw.roylab.com/hw
Ingress will use its own cert and use https protocol

User will redirected to:
https://hw.roylab.com/hw



CLEAN-UP Hello World
--------------------
./del-hello-world.sh