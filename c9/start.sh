#!/bin/bash

# Create swapfile with sudo
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Configure cron if HOST is set
if [ -n "$HOST" ]; then
  echo "**** HOST set, configuring cron ****"
  echo "*/15 * * * * root /usr/local/bin/ping_host.sh >> /var/log/cron.log 2>&1" | sudo tee /etc/cron.d/ping-host
  sudo chmod 0644 /etc/cron.d/ping-host
  sudo crontab /etc/cron.d/ping-host
  sudo cron
fi

# Execute the original command (from base image)
exec /init
