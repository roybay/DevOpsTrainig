Connect to cloud providers:

		terraform init

Run plan which will do is go out against the provider's other resources to determine if any of the newly resourced specifications that have been added are existing, or not existing, if there's any conflicts, and it will determine a diff between what is existing in the providers, and what we're trying to add to that particular environment.


		terraform plan

Build the resources 

		terraform build
		terraform apply
        	terraform apply -var-file="starter.tfvars"


