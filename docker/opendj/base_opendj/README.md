# Build Base OpenDJ Image

1.	Run base_opendj.sh script

	```
	<Local_Machine>/base_opendj.sh
	```

	Altemetly CI/CD process will run this script in it's local:

## What does base_opendj.sh script do? 

This script create base image:

1. 	Build Docker image
1.	Created linux user and groups
1.	Set required environment variables 
1.	Copy opendj bits.
1.	Login Docker registery
1.	Push Docker image to Docker registery
1.	Logout from Docker registery 

Not: It does not configure or setup opendj. 