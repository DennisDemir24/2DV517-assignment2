#!/bin/bash

# Uploads all files except *.secret and upload.sh in the CURRENT DIRECTORY to
# the server directory ~/Ansible/. If this directory does not exist, it will be created.

# Create these files and put your Ansible controller FIP and path/to/key.pem in them.
ip="./ac_ip.secret"
key="./bashkey.secret"

server=$(cat "$ip")
user='ubuntu'
pem=$(cat "$key")

# This will automatically fail if directory is already present. 
ssh $user@$server -i "$pem" 'sudo mkdir Ansible'

# Ignores upload.sh and files ending in *.secret IF IN CURRENT DIR 
# (do not put secrets in subfolders).
for f in $(pwd)/*; do
    if [ "${f: -9}" == "upload.sh" ] || [[ "${f}" == *.secret ]]; then
        echo "Skipping: $f"
    else
        if [[ -d $f ]]; then
            echo "Uploading directory: $f"
            scp -r -i "$pem" "$f" $user@$server:./Ansible/
        else
            echo "Uploading file: $f"
	        scp -i "$pem" "$f" $user@$server:./Ansible/
	    fi
    fi
done

# ADDITIONS:

#Creating directories for clouds.yaml and .ssh key

ssh $user@$server -i "$pem" 'sudo mkdir ./.ssh'
echo "Creating .ssh directory"
ssh $user@$server -i "$pem" 'mkdir ./.config'
echo "Creating .config directory"
ssh $user@$server -i "$pem" 'sudo mkdir ./.config/openstack'
echo "Creating .config/openstack directory"

# Uploading clouds.yaml to the right location

scp -i "$pem" ~/.config/openstack/clouds.yaml $user@$server:~/.config/openstack
echo "transporting clouds.yaml file"

# Uploading key 
# Update your key name!

scp -i "$pem" ~/.ssh/my_key_name.pem $user@$server:~/.ssh/
echo "transporting key"