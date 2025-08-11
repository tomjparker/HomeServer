#!/bin/bash
set -e


IFACE="eth0"                 # Pi’s primary interface (eth0 or wlan0)
WG_PORT="51820" 

curl https://download.argon40.com/argon1.sh | bash # 'argonone-config' in terminal to update settings once pi-case installation complete. Might need reboot after this. 

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing dependencies..."
sudo apt install -y curl git dnsutils unzip

echo "Installing Pi-hole..."
curl -sSL https://install.pi-hole.net | bash /dev/stdin --unattended

echo "Installing Unbound..."
sudo apt install -y unbound # Better for privacy than google/cloudflare

echo "Copying configs..."
sudo cp config/pihole/* /etc/pihole/
sudo cp config/unbound/* /etc/unbound/unbound.conf.d/
sudo cp config/dnsmasq/* /etc/dnsmasq.d/

echo "Restarting services..."
sudo systemctl restart pihole-FTL
sudo systemctl restart unbound

# Still need Wireguard

# still need suricata (IDS)

# Still need ntopng - network flow monitoring

# Possibly also Log2RAM to reduce sd wear due to sd card limited write cycles deals with high syslog and auth.log writes logging on the memory then eventually syncs to sd card, preventing excessive writes. 

echo "Setup complete!"