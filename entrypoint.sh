#!/bin/bash

# Setup password root dinamis
echo "root:${SSH_PASSWORD:-hillzacky}" | chpasswd

# Start SSH
/usr/sbin/sshd &

# Start sshx (Akses Browser - Sangat Stabil)
echo "[INFO] Starting sshx..."
sshx &

# Start playit.gg (Akses Terminal/Putty)
echo "[INFO] Starting playit.gg..."
playit &

# Menjaga container tetap hidup selamanya
echo "[INFO] Container running. Check logs for sshx/playit links."
tail -f /dev/null
