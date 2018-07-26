# Terraform Learning

## Download CLI

#### Azure

Reference: https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest
brew update && brew install azure-cli

#### AWS

Requires pip install

Reference: https://pip.pypa.io/en/stable/installing/

curl https://bootstrap.pypa.io/get-pip.py | python3

sudo python get-pip.py

Reference: https://aws.amazon.com/cli/

pip install awscli

#### Google

Reference: https://cloud.google.com/sdk/gcloud/

Install Terraform

Reference: https://www.terraform.io/downloads.html

Add .bash_profile environment variable

#### Setting Path for Terraform

PATH="/Users/rbahian/Desktop/Software/Terraform:${PATH}"

export PATH


****
## Connect to cloud providers:

1.	Create GCP account and project and log into the console 

1.	Go to IAM 

1.	Click on the service account section

1.	Create service account

1.	Name it terraform_starter

1.	Click on roles

1.	Pick a role. There are a lot of different roles for all the different things.

1.	Click furnish a new private key. 

1.	Select JSON 

1.	Click save 

1.	It will download that key. Change the name to account.json

1.	Save it parent directory of the project repo

1.	Create connections.tf above 

1. 	Run

		terraform init


1.	Run plan which will do is go out against the provider's other resources to determine if any of the newly resourced specifications that have been added are existing, or not existing, if there's any conflicts, and it will determine a diff between what is existing in the providers, and what we're trying to add to that particular environment.

		terraform plan


1.	Build the resources 

		terraform build

1.	After initial build apply will be used

		terraform apply
		terraform apply -var-file="starter.tfvars"

***
## Create Resource 


***

## Terraform Comments 

### Useful comments  
1.	Create .terraform folder and downloads necesery plugins to communicate to cloud provider(s)

		terraform init
1.	It check terraforms code and make sure that there is no issue. It usually works fine

		terraform plan

1.	It applies the change to the infrastructure 

		terraform apply

1.	It destroy all infrastructure in all platforms

		terraform destroy

1.	It check terraforms code and make sure that there is no issue. Don’t need terraform plan

		terraform validate

1.	It fix the formatting issues. It usually works fine

		terraform fmt

1.	Without actually executing against the platform. it has sub commands

11.	list
11.	mv
11.	pull
11.	push
11.	rm
11.	show

		terraform state show <resource_name>
		Ex: terraform state show google_compute_network.our_development_network

1.	Create the diagram for all infrasturcture

11.	There is a dependency: GraphViz or dot
	
		terraform graph | dot -Tsvg > graph.svg
	 

### Good to know comments

1.	terraform workspace offers many workspaces. new	creates a new workspace 

		terraform workspace new <name>

1.	list 	List Workspaces

		terraform workspace list 

1.	select 	Select a workspace

		terraform workspace select <name>

1.	delete 	Delete a workspace

		terraform workspace delete <name>

1.	show 	Show the name of the current workspace

		terraform workspace show
 
1.	Return output variables assigned value

		terraform output

1.	imports the existing configuration from cloud provider into state file 

		terraform import

1.	force to unlock but it is kind off dengerus because it may create an conflict on the state

		terraform force-unlock

1.	if there is any changes on the cloud configuration 

		terraform refresh

1.	allow as to select any resource and then terraform apply it create that resource again. 

		terraform taint <resource name>

1.	just remove the resource to taint list

		terraform untaint <resource name>





