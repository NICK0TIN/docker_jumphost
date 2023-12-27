#!/bin/bash


SSH_USER=${SSH_USER:-default_user}

#!/bin/bash
SSH_USER_HOME="/home/$SSH_USER"
SSH_USER_PUBLIC_KEY="$SSH_USER_HOME/.ssh/id_rsa.pub"
SSH_USER_PRIVATE_KEY="$SSH_USER_HOME/.ssh/id_rsa"
#echo $ONLY_ACCEPT_KEY



if [ $ONLY_ACCEPT_KEY ]; then
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    #sed -i 's,#HostKey /etc/ssh/ssh_host_rsa_key,#HostKey /etc/.secrets/ssh-key-jumphost ,' /etc/ssh/sshd_config && \ to add: var that chooses key file location
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    #mkdir /etc/.secrets
fi

mkdir -p $SSH_USER_HOME/.ssh



 if [ ! -f $SSH_USER_PRIVATE_KEY ]; then
    echo "it runs"
    touch $SSH_USER_PRIVATE_KEY
    ssh-keygen -q -t rsa -N '' -f $SSH_USER_PRIVATE_KEY <<<y >/dev/null 2>&1 # if not mounted via volume or secret 
  fi
    adduser -h "/home/${SSH_USER}" "${SSH_USER}"
    passwd -d $SSH_USER
    chown -R $SSH_USER:$SSH_USER $SSH_USER_HOME
    chmod -R 700 $SSH_USER_HOME/.ssh/
    chmod 600 $SSH_USER_PRIVATE_KEY
/usr/sbin/sshd -D -e
