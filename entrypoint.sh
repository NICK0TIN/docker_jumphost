#!/bin/bash

# Generate SSH host keys if they do not exist
#



# SSH_USER_HOME="/home/$SSH_USER"
# SSH_USER_AUTHORIZED_KEYS="$SSH_USER_HOME/.ssh/authorized_keys"
# SSH_USER_PUBLIC_KEY="$SSH_USER_HOME/.ssh/id_rsa.pub"
#SSH_USER_PRIVATE_KEY="/etc/.secrets/ssh-key-jumphost"
SSH_USER_PRIVATE_KEY=$SSH_PRIVATE_KEY_FILE
echo "hello world!"
# Check if custom SSH key and password are provided
if [ -f "$SSH_USER_PRIVATE_KEY" ] ; then
  mkdir -p "$SSH_USER_HOME/.ssh"
  
  # Add SSH key to authorized keys
  #cp /etc/.secrets/ssh-public-key "$SSH_USER_PUBLIC_KEY"
  #cp /etc/.secrets/authorized_keys "$SSH_USER_AUTHORIZED_KEYS"
  #chmod -R 600  "$SSH_USER_PRIVATE_KEY" 

  # Create user with password
  adduser -D -h "$SSH_USER_HOME" -s /bin/bash -G $SSH_USER -u 1000 $SSH_USER --disabled-password
  chown -R $SSH_USER:$SSH_USER "$SSH_USER_HOME/.ssh"
else
  echo "Could not find File SSH_USER_PRIVATE_KEY: $SSH_USER_PRIVATE_KEY"
  exit 2 

fi

# Start the SSH server
/usr/sbin/sshd -D



