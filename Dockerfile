FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
# Hapus ARG, gunakan ENV agar nilai bisa diambil dari Railway Variables
ENV NGROK_TOKEN=""

RUN apt update && apt upgrade -y && apt install -y \
    openssh-server wget unzip vim curl python3 && \
    wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip -O /ngrok.zip && \
    unzip /ngrok.zip -d /usr/local/bin && \
    rm /ngrok.zip && \
    mkdir -p /run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'root:hillzacky' | chpasswd

# Membuat skrip startup
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'ngrok authtoken $NGROK_TOKEN' >> /start.sh && \
    echo 'ngrok tcp 22 --log=stdout > /dev/null &' >> /start.sh && \
    echo 'sleep 5' >> /start.sh && \
    echo '/usr/sbin/sshd -D' >> /start.sh && \
    chmod +x /start.sh

EXPOSE 22

CMD ["/start.sh"]
