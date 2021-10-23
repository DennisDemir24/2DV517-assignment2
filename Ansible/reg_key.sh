#!/bin/bash

# change to your own key
chmod 400 ~/.ssh/my_key_name.pem
eval $(ssh-agent)
ssh-add -k ~/.ssh/my_key_name.pem