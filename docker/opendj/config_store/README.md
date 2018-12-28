# Build cfgStore OpenDJ Image

1.	Run opendj_cfg_store.sh script

	```
	<Local_Machine>/opendj_cfg_store.sh
	```

	Altemetly CI/CD process will run this script in it's local:

## What does opendj_cfg_store.sh script do? 

This script create config store image. 

1.	Copy opendj schema(s), structure and automations scripts
1.	Set required environment variables
1.	Run setup_opendj.sh script in the image which will setup config store 
1.	Login Docker registery
1.	Push Docker image to Docker registery
1.	Logout from Docker registery 