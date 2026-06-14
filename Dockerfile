FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    SSH_PASSWORD="hillzacky"

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server wget unzip vim curl python3 ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip -O /tmp/ngrok.zip \
    && unzip /tmp/ngrok.zip -d /usr/local/bin && rm /tmp/ngrok.zip \
    && curl -Lo /usr/local/bin/playit https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64 \
    && chmod +x /usr/local/bin/playit

RUN mkdir -p /run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 22 80 443 3306 4040 5432 5700 5701 5010 6800 6900 8080 8888 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
