#!/bin/bash

# Mengatur password root tanpa ketergantungan PAM
# Menggunakan openssl untuk men-generate hash yang kompatibel
PASSWORD_HASH=$(openssl passwd -6 "${SSH_PASSWORD:-hillzacky}")
usermod --password "$PASSWORD_HASH" root

# Start SSH
/usr/sbin/sshd &

# Start tunnel (Menggunakan & agar tidak memblokir entrypoint)
echo "[INFO] Starting sshx..."
sshx &

echo "[INFO] Starting playit.gg..."
playit &

# Menjaga container tetap aktif
echo "[INFO] Services started successfully."
tail -f /dev/null
