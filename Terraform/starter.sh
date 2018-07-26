terraform validate

terraform fmt

terraform plan -var-file="variables.tfvars"

echo "yes" | terraform apply -var-file="variables.tfvars"
