#!/bin/bash

echo "======================="
echo " RAILWAY VPS"
echo "======================="
echo " User: root"
echo " Pass: 2010"
echo "======================="

/usr/sbin/sshd
echo "SSH server started"

TAILSCALE_AUTH_KEY="tskey-auth-k8JCrFbY1T11CNTRL-NiYDjq9ACs3cuZdVLbZus3Zw29Ko61jk"

echo "Starting Tailscale..."
tailscaled --tun=userspace-networking --state=mem: > /dev/null 2>&1 &
sleep 5

tailscale up --authkey="$TAILSCALE_AUTH_KEY" --hostname=railway-vps --accept-dns=false
TS_IP=$(tailscale ip -4 2>/dev/null)

PORT=${PORT:-8080}

mkdir -p /www
cat > /www/index.html <<EOF
<!DOCTYPE html>
<html>
<head><title>Railway VPS</title></head>
<body>
<h1>Railway VPS Running</h1>
<p><b>User:</b> root</p>
<p><b>Password:</b> 2010</p>
<p><b>Tailscale IP:</b> $TS_IP</p>
<p><b>SSH:</b> ssh root@$TS_IP</p>
</body>
</html>
EOF

echo "Starting web server on port $PORT..."
cd /www && python3 -m http.server $PORT > /dev/null 2>&1 &

echo ""
echo "======================="
echo " VPS IS RUNNING"
echo "======================="
echo " Tailscale IP: $TS_IP"
echo " SSH: ssh root@$TS_IP  (password: 2010)"
echo "======================="

while true; do
    sleep 3600
done
