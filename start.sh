#!/bin/bash

TAILSCALE_AUTH_KEY="tskey-auth-k8JCrFbY1T11CNTRL-NiYDjq9ACs3cuZdVLbZus3Zw29Ko61jk"

/usr/sbin/sshd

mkdir -p /var/lib/tailscale /var/run/tailscale /var/cache/tailscale

tailscaled --tun=userspace-networking \
           --state=/var/lib/tailscale/tailscaled.state \
           --socket=/var/run/tailscale/tailscaled.sock &
sleep 5

if ! pgrep -x tailscaled > /dev/null; then
    tailscaled --state=/var/lib/tailscale/tailscaled.state \
               --socket=/var/run/tailscale/tailscaled.sock &
    sleep 5
fi

TS_IP="NOT CONNECTED"
if pgrep -x tailscaled > /dev/null; then
    tailscale --socket=/var/run/tailscale/tailscaled.sock up \
        --authkey="$TAILSCALE_AUTH_KEY" \
        --hostname=railway-vps \
        --accept-dns=false
    TS_IP=$(tailscale --socket=/var/run/tailscale/tailscaled.sock ip -4)
fi

PORT=${PORT:-8080}
mkdir -p /www
cat > /www/index.html <<EOF
<!DOCTYPE html>
<html><head><title>Railway VPS</title></head><body>
<h1>Railway VPS</h1>
<p>User: root</p>
<p>Pass: 2010</p>
<p>Tailscale IP: $TS_IP</p>
</body></html>
EOF

python3 -m http.server $PORT -d /www > /dev/null 2>&1 &

echo ""
echo "======================="
echo " RAILWAY VPS ACTIVE"
echo "======================="
echo " User       : root"
echo " Password   : 2010"
echo " Tailscale  : $TS_IP"
echo " SSH        : ssh root@$TS_IP"
echo " Node.js    : $(node -v)"
echo " npm        : $(npm -v)"
echo " Python     : $(python3 --version)"
echo " Workspace  : /workspace"
echo "======================="

while true; do
    sleep 3600
done
