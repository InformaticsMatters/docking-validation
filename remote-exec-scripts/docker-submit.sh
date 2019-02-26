#!/bin/bash

set -e

SSH_KEY=$SSH_KEY
KNOWN_HOSTS=$KNOWN_HOSTS

if [ "$#" -eq 0 ]; then
  echo "ERROR: No arguments specified"
  exit 1
fi

# setup SSH
echo "Setting up keys"
if [ ! -d ~/.ssh ]; then
  echo "Creating .ssh directory"
  mkdir ~/.ssh
  chmod 700 ~/.ssh
fi
echo $KNOWN_HOSTS > ~/.ssh/known_hosts
eval $(ssh-agent -s) 
ssh-add <(echo "$SSH_KEY") 
ssh-add -l


# start job
echo "Submitting job"
./tej-submit.sh $@
