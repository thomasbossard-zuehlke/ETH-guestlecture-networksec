# ETH-guestlecture-networksec
Accompanying information to the guest lecture at ETH

Install Terraform: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

clone the repo, you'll need main.tf, variables.tf and providers.tf.

Make sure to create an SSH key and add the pubkey to the variables. 

navigate to the folder containting the terraform files. 

az login --scope https://graph.microsoft.com/.default
to initialize, run "terraform init -upgrade"
To plan, run "terraform plan" 
To deploy, run "terraform apply"
