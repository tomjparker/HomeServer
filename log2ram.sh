echo "[*] (Optional) Installing Log2RAM..."
sudo apt install -y git
if [ ! -d /tmp/log2ram ]; then
  git clone https://github.com/azlux/log2ram /tmp/log2ram
  cd /tmp/log2ram
  sudo ./install.sh
  cd -
fi
# Flush RAM logs to disk every 10 minutes (reduce loss on crash)
( sudo crontab -l 2>/dev/null; echo "*/10 * * * * /usr/sbin/log2ram write >/dev/null 2>&1" ) | sudo crontab -
