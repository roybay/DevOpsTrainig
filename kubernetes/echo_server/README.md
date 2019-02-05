README - Echo Server 
====================
./run-echo-server.sh

minikube ip 
will show ip address of minikibue.
Ex: 192.168.99.100

kubectl get svc -n echo

NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
echo-service   ClusterIP   10.108.151.199   <none>        8080/TCP,8443/TCP   4m33s

It will not give external ip address once service type ClusterIP 
Thus, you need to use node ip address. 

Below URL shows echo Server application. 
Can not be display without ingress becuase node port is not provided. 

Once echo-ingess is deployed. 
it only accept request comming from specified hostname and path
echo.roylab.com
Thus, /etc/hosts file need to be modifed 

192.168.99.100 echo.roylab.com

Than, we can use 
http://echo.roylab.com/echo
Ingress will use its own cert and use https protocol

User will redirected to:
https://echo.roylab.com/echo
it will show Hostname load balanced and each request will go different host
---------------------
Ingress controller can be implemented in a way that it generet a cookie in order to enable sticky session.
./run-echo-server-sticky.sh
Now, all request from same browser will go same host 
---------------------
SSL communication terminated in ingress level and ingress send the request non-ssl inside the cluster
However, it can be set to use SSL cert al the way down to echo-server pod.
./run-echo-server-sticky-ssl.sh
Now, 
https://echo.roylab.com/echo
It uses self-signed cert and backend protocol also https. 


CLEAN-UP Echo Server
--------------------
./del-echo-server.sh