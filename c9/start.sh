#!/bin/bash

# Create swap if not exists
if [ ! -f /swapfile ]; then
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
fi

# Enable swap
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Configure cron if HOST exists
if [ -n "$HOST" ]; then
    echo "*/15 * * * * /usr/local/bin/ping_host.sh" | sudo tee /etc/cron.d/ping-host
    sudo chmod 0644 /etc/cron.d/ping-host
    sudo crontab /etc/cron.d/ping-host
fi

# Start original cloud9 process
exec /init
