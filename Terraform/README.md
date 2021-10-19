# Terraform

*WIP!*

## Using Terraform:

1. Rename *terraform* to *terraform.tfvars*
2. Replace values in *terraform.tfvars* with your own
3. Install terraform (see below)
4. Run <code>terraform plan</code> to check for errors
5. Run <code>terraform apply</code> when ready to deploy

## Install instructions (Linux):

    TRELEASE=0.14.7
    
    wget https://releases.hashicorp.com/terraform/${TRELEASE}/terraform_${TRELEASE}_linux_amd64.zip

    unzip terraform_${TRELEASE}_linux_amd64.zip
    
    sudo mv terraform /usr/local/bin/

    mkdir Terraform
    
    cd Terraform