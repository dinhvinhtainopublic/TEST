# ==========================================
#      🚀 WEBTOP + NGROK REMOTE TUNNEL
#            ✨ VPS ON RAILWAY ✨
# ==========================================
FROM linuxserver/webtop:latest
USER root

# Cài đặt các công cụ cần thiết
RUN apk update && apk add --no-cache curl wget netcat-openbsd bash tar

# Tải ngrok bằng phương pháp an toàn nhất (có User-Agent để tránh bị chặn)
RUN curl -A "Mozilla/5.0" -L https://bin.equinox.io/c/bPR9B2h3Y6h/ngrok-v3-stable-linux-amd64.tgz -o /tmp/ngrok.tgz && \
    tar -xzf /tmp/ngrok.tgz -C /usr/local/bin && \
    rm /tmp/ngrok.tgz

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
# Railway lấy NGROK_AUTHTOKEN từ tab Variables \
ngrok config add-authtoken ${NGROK_AUTHTOKEN}; \
\
echo '------------------------------------------'; \
echo '👇 LINK TRUY CẬP CỦA BẠN:'; \
# Chạy ngrok và in log trực tiếp \
ngrok http 3000 --log stdout & \
\
sleep 10; \
echo '------------------------------------------'; \
\
while true; do echo OK | nc -l -p 8080; done"]
