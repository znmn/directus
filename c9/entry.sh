#!/bin/bash
sudo su

# Create and enable a 2GB swap file
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# Change directory to the Cloud9 Core repository
cd /c9sdk

# Start the Cloud9 Core server with basic authentication using long options:
# --listen to bind to all interfaces, --port and --auth for port and credentials.
echo "run ${USERNAME}:${PASSWORD} on ${PORT}"
exec node server.js --listen 0.0.0.0 --port ${PORT} --auth ${USERNAME}:${PASSWORD}
