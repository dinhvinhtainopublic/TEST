# ==========================================
#   🚀 WEBTOP + NGROK HTTP (PAID)
#   ✅ REMOTE QUA BROWSER 100%
# ==========================================
FROM linuxserver/webtop:latest

USER root

# Install ngrok
RUN apk update && \
    apk add --no-cache curl tar bash netcat-openbsd && \
    wget -qO- https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz \
    | tar xz -C /usr/local/bin

# Env
ENV PUID=1000
ENV PGID=1000
ENV TZ=Asia/Ho_Chi_Minh

EXPOSE 3000
EXPOSE 8080

# s6 service for ngrok
RUN mkdir -p /etc/services.d/ngrok

RUN printf '#!/usr/bin/execlineb -P\n\
with-contenv\n\
ngrok config add-authtoken ${NGROK_AUTHTOKEN}\n\
ngrok http 3000 --region ap\n' \
> /etc/services.d/ngrok/run && chmod +x /etc/services.d/ngrok/run

# Keep-alive service
RUN mkdir -p /etc/services.d/keepalive
RUN printf '#!/bin/sh\n\
while true; do echo OK | nc -l -p 8080; done\n' \
> /etc/services.d/keepalive/run && chmod +x /etc/services.d/keepalive/run

# START (PHẢI là /init)
CMD ["/init"]
