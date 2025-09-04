#!/bin/bash
set -e

echo "[*] Installing WireGuard..."
sudo apt install -y wireguard

echo "[*] Generating WireGuard keys..."
WG_DIR="/etc/wireguard"
sudo mkdir -p "$WG_DIR"
sudo chmod 700 "$WG_DIR"
if [ ! -f "$WG_DIR/server_private.key" ]; then
  (umask 077; sudo wg genkey | sudo tee "$WG_DIR/server_private.key" >/dev/null)
  sudo sh -c "wg pubkey < $WG_DIR/server_private.key > $WG_DIR/server_public.key"
fi
SERVER_PRIV=$(sudo cat $WG_DIR/server_private.key)

# Minimal wg0.conf (tweak Address to a subnet you like)
echo "[*] Writing wg0.conf..."
sudo tee $WG_DIR/wg0.conf >/dev/null <<EOF
[Interface]
Address = 10.8.0.1/24
ListenPort = ${WG_PORT}
PrivateKey = ${SERVER_PRIV}
# SaveConfig = true

# Add peers below like:
# [Peer]
# PublicKey = <peer_pubkey>
# AllowedIPs = 10.8.0.2/32
EOF

sudo chmod 600 $WG_DIR/wg0.conf
sudo systemctl enable wg-quick@wg0
# Do NOT start yet if you haven’t opened firewall/port forward; enable when ready
# sudo systemctl start wg-quick@wg0