# ==========================================
#      🚀 WEBTOP + NGROK REMOTE TUNNEL
#            ✨ VPS ON RAILWAY ✨
# ==========================================
FROM linuxserver/webtop:latest
USER root

# Cài đặt ngrok
RUN apk update && \
    apk add --no-cache curl wget netcat-openbsd bash tar && \
    curl -s https://bin.equinox.io/c/bPR9B2h3Y6h/ngrok-v3-stable-linux-amd64.tgz | tar xz -C /usr/local/bin

ENV PUID=1000
ENV PGID=1000
ENV TZ=Asia/Ho_Chi_Minh

EXPOSE 3000
EXPOSE 8080

CMD ["bash","-c","\
echo '🖥️  WEBTOP ĐANG KHỞI ĐỘNG...'; \
/init & sleep 5; \
\
echo '🌐 ĐANG KẾT NỐI NGROK...'; \
ngrok config add-authtoken ${NGROK_AUTHTOKEN}; \
\
# Chạy ngrok và bắt nó in log trực tiếp ra màn hình \
echo '👇 XEM LINK TRUY CẬP DƯỚI ĐÂY (Tìm dòng url=https://...):'; \
ngrok http 3000 --log stdout & \
\
# Giữ Railway sống \
while true; do echo OK | nc -l -p 8080; done"]
