echo "[*] Installing Suricata (IDS)..."
sudo apt install -y suricata

# Configure AF_PACKET on your interface; keep it simple
sudo tee /etc/suricata/suricata.yaml >/dev/null <<'EOF'
%YAML 1.1
---
vars:
  address-groups:
    HOME_NET: "[192.168.0.0/16]"
af-packet:
  - interface: eth0
    cluster-id: 99
    cluster-type: cluster_flow
    defrag: yes
    use-mmap: yes
    mmap-locked: yes
    tpacket-v3: yes
    ring-size: 2048
    buffer-size: 64535
    checksum-checks: auto
    # Set 'copy-mode: ips' + nfqueue only for IPS (not recommended here)

outputs:
  - eve-log:
      enabled: yes
      filetype: regular
      filename: /var/log/suricata/eve.json
      community-id: yes
      types: [ alert, dns, http, tls, flow, drop ]
  - fast:
      enabled: yes
      filename: /var/log/suricata/fast.log
      append: yes

logging:
  default-log-level: notice
  outputs:
    - console:
        enabled: yes
        level: notice
EOF

# Replace eth0 with your ${IFACE}
sudo sed -i "s/interface: eth0/interface: ${IFACE}/" /etc/suricata/suricata.yaml
sudo sed -i "s/HOME_NET: \"\[192.168.0.0\/16]\"/HOME_NET: \"\[${LAN_CIDR}]\"/" /etc/suricata/suricata.yaml

sudo systemctl enable suricata
sudo systemctl restart suricata
