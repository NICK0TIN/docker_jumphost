
FROM alpine:latest

RUN apk add --no-cache openssh-server bash openssh-client

ENV ONLY_ACCEPT_KEY=1
RUN ssh-keygen -A        

EXPOSE 22

COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT /usr/local/bin/entrypoint.sh

