#!/bin/bash

# Generate SSH host keys if they do not exist
#

SSH_USER_HOME="/home/$SSH_USER"
SSH_USER_AUTHORIZED_KEYS="$SSH_USER_HOME/.ssh/authorized_keys"
SSH_USER_PUBLIC_KEY="$SSH_USER_HOME/.ssh/id_rsa.pub"
SSH_USER_PRIVATE_KEY="$SSH_USER_HOME/.ssh/id_rsa"

# Check if custom SSH key and password are provided
if [ -f "/etc/.secrets/authorized_keys" ] && [ -f "/etc/.secrets/ssh-private-key" ] && [ -f "/etc/.secrets/ssh-public-key" ]  ; then
  mkdir -p "$SSH_USER_HOME/.ssh"
  
  # Add SSH key to authorized keys
  cp /etc/.secrets/ssh-public-key "$SSH_USER_PUBLIC_KEY"
  cp /etc/.secrets/ssh-private-key "$SSH_USER_PRIVATE_KEY"
  cp /etc/.secrets/authorized_keys "$SSH_USER_AUTHORIZED_KEYS"
  chmod -R 600 "$SSH_USER_AUTHORIZED_KEYS" "$SSH_USER_PRIVATE_KEY" 

  
  # Create user with password
  adduser -D -h "$SSH_USER_HOME" -s /bin/bash -G $SSH_USER -u 1000 $SSH_USER --disabled-password
  chown -R sshuser:sshuser "$SSH_USER_HOME/.ssh"
else
  ssh-keygen -A
fi

# Start the SSH server
/usr/sbin/sshd -D

# https://kubernetes.io/docs/concepts/configuration/secret/
#Next 
#--> check how to pull from dockerhub
# https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
#--> check how to deploy  keys

# https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data
# https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#provide-prod-test-creds