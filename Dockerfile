
FROM alpine:latest


RUN apk add --no-cache openssh-server bash openssh-client


#ENV SSH_USER=sshuser
#RUN adduser -D -h "/home/${SSH_USER}" "${SSH_USER}"

#ARG SSH_PASSWORD
#ARG SSH_PRIVATE_KEY
# ENV SSH_PUBLIC_KEY test
# ENV SSH_PRIVATE_KEY_FILE test
ENV ONLY_ACCEPT_KEY=1



# COPY conditional_config.sh /tmp/
# RUN     chmod +x /tmp/conditional_config.sh
# RUN     /tmp/conditional_config.sh
# RUN     rm -f /tmp/conditional_config.sh

#RUN chmod 600 /home/${SSH_USER}/.ssh/id_rsa


# Keys to start SSHD daemon
RUN ssh-keygen -A        
# Keys to start SSHD daemon
# Voeg de SSHD-configuratie toe
EXPOSE 22
COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT /usr/local/bin/entrypoint.sh




#CMD ["/usr/sbin/sshd", "-D"]
