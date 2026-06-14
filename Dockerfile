FROM debian:bookworm-slim

# Install dependencies (Tanpa cache untuk mempercepat build)
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server curl python3 ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install sshx & playit.gg
RUN curl -sSf https://sshx.io/get | sh \
    && curl -Lo /usr/local/bin/playit https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64 \
    && chmod +x /usr/local/bin/playit

# Konfigurasi SSH dasar
RUN mkdir -p /run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Copy entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
