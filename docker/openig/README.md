# OpenIG Docker Images

If IG doesn't find $HOME/.openig/config/config.json at startup, it uses its own, default config.json
By default, the router defined in config.json looks for routes in $HOME/.openig/config/routes

OpenIG Docker file uses out of box forgerock docker images and copy config folder to container and change the owner to forgerock. 

##Routes Folder 

This images has simpleApp deployment in order to work with below routes. 
04-pep.json route also requires to have openam installed and configured in the same namespace.

1.	00-hello.json
	
		<openig>:8080/hello 
		Generete static response displaying "hello, world!"

1.	01-public.json

		<openig>:8080/public.html 
		Revers proxy to web server and desplays public.html page

1.	04-pep.json

		<openig>:8080/private.html
		Requires openam basic authentication. Once user is authenticated, reverse proxy to webserver and displays private.html page

1. 	05-home.json

		<openig>:8080/home
		Revers proxy to simpleApp and desplays home page

1.	06-login.json
	
		<openig>:8080/login
		Requires basic authentication where openig POST static username and password via rest call. Once user is authenticated, displays home page of simpleApp

