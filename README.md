# 2DV517-assignment2

This is assignment 2 for the course 2dv517.

## Prerequisites

Terraform installed locally. Openstack cli configured with the RC file from Openstack. Git.

# Install instructions

git clone this repo to your ~ directory.

## Terraform
    cd Terraform

Rename *terraform* to *terraform.tfvars*

Replace values in *terraform.tfvars* with your own

Run 

    terraform plan

if it complains, run 

    terraform init

then <code>terraform plan</code> again. Check for errors. 

When you are ready, run

    terraform apply 

when you are ready.

## Ansible
    cd ../Ansible

Change the parameters in the reg_key.sh to point to your own key and run it:

    bash reg_key.sh

Ssh into your Acme_AC (Ansble controller) server. Check <code>inventory</code> for the ac server floating ip. Then exit to your local machine again. This is to accept fingerprint and add the server ip to known hosts.

    ssh ubuntu@acfloatingIPhere -i ~/path/to/ssh_key.pem
    exit

Download clouds.yaml from Openstack and put it in ~/.config/openstack/clouds.yaml (create directory if it does not exist).

Run

    bash upload.sh

Ssh into the Ansible controller again.

Add your ssh-key, this prevents "permission denied" errors by running the same reg_key bash but now on Ansible machine.

    bash reg_key.sh

Edit <code>ansible.cfg</code> and <code>vars/all</code> and replace the placeholder values with your own. Your key should be in ~/.ssh/

Ping all with Ansible:

    ansible all -m ping

You may get an error about accepting the fingerprints of all servers, answer <code>yes</code> for each server (keep typing yes even if the terminal acts weird) until you are back at the default prompt ($).

Ping again, everything should now be green.
