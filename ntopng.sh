echo "[*] Installing ntopng..."
sudo apt install -y ntopng

# Minimal config: listen on your interface, restrict to LAN
sudo tee /etc/ntopng/ntopng.conf >/dev/null <<EOF
-i=${IFACE}
--http-port=3000
--local-networks="${LAN_CIDR}"
--disable-login=1
EOF

sudo systemctl enable ntopng
sudo systemctl restart ntopng

# UFW: allow dashboard only from LAN
sudo ufw allow from ${LAN_CIDR} to any port 3000 proto tcp
