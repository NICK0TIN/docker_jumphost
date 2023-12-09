# Gebruik een basisbeeld, bijvoorbeeld Ubuntu
FROM alpine:latest

# Install openssh-server
RUN apk add --no-cache openssh-server

# Maak een SSH-gebruiker aan (vervang 'sshuser' door je eigen waarde)
ENV SSH_USER=sshuser


# Voeg wachtwoord en SSH-sleutel toe als build-args (je kunt deze waarden vervangen door je eigen gegevens)
ARG SSH_PASSWORD
ARG SSH_PRIVATE_KEY
ARG SSH_PUBLIC_KEY


# Voeg de SSHD-configuratie toe
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Voeg een entrypoint-script toe
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
# Open poort 22 voor SSH
EXPOSE 22

# Start de SSH-server bij het opstarten van de container
CMD ["/usr/sbin/sshd", "-D"]