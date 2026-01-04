# ==========================================
#      🚀 WEBTOP + NGROK REMOTE TUNNEL
#            ✨ VPS ON RAILWAY ✨
# ==========================================
FROM linuxserver/webtop:latest
USER root

# Cài đặt các công cụ và ngrok từ GitHub (Tránh lỗi gzip)
RUN apk update && \
    apk add --no-cache curl wget netcat-openbsd bash tar && \
    wget -q https://bin.equinox.io/c/bPR9B2h3Y6h/ngrok-v3-stable-linux-amd64.tgz -O ngrok.tgz && \
    tar -xzf ngrok.tgz -C /usr/local/bin && \
    rm ngrok.tgz

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
# Chạy ngrok và in log ra màn hình \
echo '------------------------------------------'; \
echo '👇 LINK TRUY CẬP SẼ XUẤT HIỆN DƯỚI ĐÂY:'; \
ngrok http 3000 --log stdout & \
\
# Đợi 5 giây để ngrok kết nối rồi in thêm một dòng ngăn cách cho dễ nhìn \
sleep 5; \
echo '------------------------------------------'; \
\
while true; do echo OK | nc -l -p 8080; done"]
