
FROM alpine:latest


RUN apk add --no-cache openssh-server


ENV SSH_USER=sshuser



#ARG SSH_PASSWORD
#ARG SSH_PRIVATE_KEY
#ARG SSH_PUBLIC_KEY
ARG SSH_PRIVATE_KEY_FILE
ARG SSH_USER
# Voeg de SSHD-configuratie toe
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's,#HostKey /etc/ssh/ssh_host_rsa_key,#HostKey /etc/.secrets/ssh-key-jumphost ,' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    mkdir /etc/.secrets
    

EXPOSE 22

COPY entrypoint.sh /usr/local/bin/
RUN /bin/bash -c '/usr/local/bin/entrypoint.sh'



#CMD ["/usr/sbin/sshd", "-D"]