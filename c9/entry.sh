#!/bin/bash
# Create and enable a 2GB swap file
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# Start Cloud9 SDK with basic authentication using the provided environment variables
exec c9sdk -l 0.0.0.0 --port ${PORT} --auth ${USERNAME}:${PASSWORD}
