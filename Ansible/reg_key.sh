#!/bin/bash

# change to your own key(!!!!CHANGE WITH YOUR OWN KEY PATH AND NAME!!!!)
chmod 400 ~/.ssh/my_key_name.pem
eval $(ssh-agent)
ssh-add -k ~/.ssh/my_key_name.pem