FROM alpine:latest

ENV AUTH_SERVER_PORT=3025
ENV WEB_PROXY_PORT=3080
ENV SSH_PROXY_PORT=3023
ENV SSH_PORT=3022

ARG TELEPORT_BIN_URL="https://github.com/gravitational/teleport/releases/download/v2.4.0/teleport-v2.4.0-linux-amd64-bin.tar.gz"
ARG TELEPORT_DIR="/opt/teleport"
ARG TELEPORT_DATA_DIR="/var/lib/teleport"

RUN apk add --no-cache --virtual builddeps curl \
 && mkdir -p $TELEPORT_DIR \
 && curl -sSL $TELEPORT_BIN_URL | tar zxf - -C $TELEPORT_DIR --strip-components 1 \
 && cd $TELEPORT_DIR \
 && ./install \
 && cd /root \
 && apk del builddeps \
 && mkdir -p $TELEPORT_DATA_DIR \
 && mkdir /lib64 \
 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

EXPOSE $AUTH_SERVER_PORT $WEB_PROXY_PORT $SSH_PROXY_PORT $SSH_PORT

CMD [ "teleport", "start" ]
