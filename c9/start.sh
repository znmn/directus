#!/bin/bash

# 1. Swap configuration
if [ ! -f /swapfile ]; then
    echo "Creating 2GB swapfile..."
    sudo fallocate -l 2G /swapfile && \
    sudo chmod 600 /swapfile && \
    sudo mkswap /swapfile
fi

# Enable swap even if it exists
echo "Activating swap..."
sudo swapon /swapfile || true
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# 2. Cleanup previous instances
echo "Cleaning up previous processes..."
sudo pkill -9 node || true
sudo pkill -9 cron || true

# 3. Cron configuration
if [ -n "$HOST" ]; then
    echo "Configuring cron job for HOST ping..."
    echo "*/15 * * * * abc /usr/local/bin/ping_host.sh >> /var/log/cron.log 2>&1" | \
        sudo tee /etc/cron.d/ping-host >/dev/null
    sudo chmod 0644 /etc/cron.d/ping-host
    sudo crontab /etc/cron.d/ping-host
else
    echo "HOST not set, skipping cron configuration"
    sudo rm -f /etc/cron.d/ping-host
fi

# 4. Fix s6 service permissions
echo "Preparing s6 services..."
sudo chmod +x /etc/services.d/*/run >/dev/null 2>&1 || true

# 5. Start the main Cloud9 process
echo "Starting Cloud9 IDE..."
exec /init
