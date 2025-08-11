#!/bin/bash
set -e

curl https://download.argon40.com/argon1.sh | bash # 'argonone-config' in terminal to update settings once pi-case installation complete. Might need reboot after this. 

echo "[*] Updating system..."
sudo apt update && sudo apt upgrade -y

echo "[*] Installing dependencies..."
sudo apt install -y curl git dnsutils unzip

echo "[*] Installing Pi-hole..."
curl -sSL https://install.pi-hole.net | bash /dev/stdin --unattended

echo "[*] Installing Unbound..."
sudo apt install -y unbound

echo "[*] Copying configs..."
sudo cp config/pihole/* /etc/pihole/
sudo cp config/unbound/* /etc/unbound/unbound.conf.d/
sudo cp config/dnsmasq/* /etc/dnsmasq.d/

echo "[*] Restarting services..."
sudo systemctl restart pihole-FTL
sudo systemctl restart unbound

echo "[*] Setup complete!"