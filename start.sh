#!/bin/bash

mkdir -p /var/run/sshd
/usr/sbin/sshd

PORT=${PORT:-8080}
mkdir -p /www
cat > /www/index.html <<EOF
<!DOCTYPE html>
<html><head><title>Railway VPS</title></head><body>
<h1>Railway VPS</h1>
<p>User: root</p>
<p>Pass: 2010</p>
</body></html>
EOF
python3 -m http.server $PORT -d /www > /dev/null 2>&1 &

echo ""
echo "======================="
echo " RAILWAY VPS"
echo "======================="
echo " User : root"
echo " Pass : 2010"
echo "======================="

while true; do
    sleep 3600
done
