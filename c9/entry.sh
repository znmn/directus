#!/bin/bash

# Create and enable a 2GB swap file
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Ensure /c9sdk is owned by the user (adjust if necessary)
sudo chown -R $USER:$USER /c9sdk

# Change directory to the Cloud9 Core repository
cd /c9sdk

# Start Cloud9 Core server
echo "Starting Cloud9: ${USERNAME}:${PASSWORD} on port ${PORT}"
exec node server.js --listen 0.0.0.0 --port ${PORT} --auth ${USERNAME}:${PASSWORD}
