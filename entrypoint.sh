#!/bin/bash
set -e

# Setup password root
echo "root:${SSH_PASSWORD}" | chpasswd

echo "[INFO] Starting SSH Service..."
/usr/sbin/sshd &

echo "[INFO] Initializing tunnel provider..."

if [ -n "$NGROK_TOKEN" ]; then
    echo "[INFO] Attempting to start Ngrok..."
    ngrok authtoken "$NGROK_TOKEN"
    ngrok tcp 22 --log=stdout > /tmp/ngrok.log 2>&1 &
    
    sleep 10
    if grep -q "credit or debit card" /tmp/ngrok.log; then
        echo "[WARN] Ngrok rejected TCP tunnel. Switching to playit.gg."
        pkill ngrok
    else
        echo "[OK] Ngrok tunnel established. Check logs for details."
        # Keep process alive
        tail -f /dev/null &
    fi
fi

# Fallback ke Playit.gg
echo "[INFO] Starting Playit.gg..."
exec playit
