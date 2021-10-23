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
ssh $user@$server -i "$pem" 'mkdir Ansible'

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