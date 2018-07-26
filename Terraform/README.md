# Terraform Learning

****
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
Connect to cloud providers:

		terraform init

Run plan which will do is go out against the provider's other resources to determine if any of the newly resourced specifications that have been added are existing, or not existing, if there's any conflicts, and it will determine a diff between what is existing in the providers, and what we're trying to add to that particular environment.


		terraform plan

Build the resources 

		terraform build
		terraform apply
		terraform apply -var-file="starter.tfvars"


