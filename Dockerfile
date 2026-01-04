# ==========================================
#     🚀 WEBTOP + NGROK TUNNEL
#           ✨ VPS ON RAILWAY ✨
# ==========================================
FROM linuxserver/webtop:latest
USER root

# Cài tool cần thiết + ngrok
RUN apk update && \
    apk add --no-cache curl wget bash netcat-openbsd jq && \
    wget -O /usr/local/bin/ngrok https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz && \
    tar -xzf /usr/local/bin/ngrok -C /usr/local/bin && \
    chmod +x /usr/local/bin/ngrok

# Env Webtop
ENV PUID=1000
ENV PGID=1000
ENV TZ=Asia/Ho_Chi_Minh

# Port
EXPOSE 3000
EXPOSE 8080

# Start Webtop + ngrok
CMD ["bash","-c","\
echo ''; \
echo '🖥️  WEBTOP ĐANG KHỞI ĐỘNG...'; \
/init & sleep 6; \
echo ''; \
echo '🔐 ĐĂNG KÝ NGROK TOKEN...'; \
ngrok config add-authtoken \"$NGROK_AUTHTOKEN\"; \
echo ''; \
echo '🌐 TẠO NGROK TUNNEL...'; \
ngrok http 3000 --log=stdout > /tmp/ngrok.log & \
sleep 8; \
LINK=$(grep -o 'https://[^ ]*ngrok[^ ]*' /tmp/ngrok.log | head -n1); \
echo ''; \
echo '=========================================='; \
echo '🔗  LINK TRUY CẬP VNC / WEBTOP:'; \
echo \"👉  $LINK\"; \
echo '=========================================='; \
echo ''; \
while true; do echo OK | nc -l -p 8080; done"]
