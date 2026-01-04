# ==========================================
#      🚀 WEBTOP + NGROK REMOTE TUNNEL
#            ✨ VPS ON RAILWAY ✨
# ==========================================
FROM linuxserver/webtop:latest
USER root

# Cài đặt các công cụ cần thiết
RUN apk update && apk add --no-cache curl wget netcat-openbsd bash tar

# Tải ngrok từ link trực tiếp ổn định
RUN wget https://bin.equinox.io/c/bPR9B2h3Y6h/ngrok-v3-stable-linux-amd64.tgz && \
    tar -xvzf ngrok-v3-stable-linux-amd64.tgz && \
    mv ngrok /usr/local/bin/ && \
    rm ngrok-v3-stable-linux-amd64.tgz

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
echo '------------------------------------------'; \
echo '👇 LINK TRUY CẬP CỦA BẠN:'; \
# Chạy ngrok và lọc lấy dòng chứa link để in ra rõ ràng \
ngrok http 3000 --log stdout & \
sleep 5; \
echo '------------------------------------------'; \
\
while true; do echo OK | nc -l -p 8080; done"]
