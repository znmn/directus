FROM linuxserver/openvscode-server:latest

# Set noninteractive mode for apt to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        screen \
        python3 \
        php-cli \
        sudo \
        nano \
        dos2unix \
        cron \
        curl \
        ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    corepack enable && \
    corepack prepare pnpm@latest --activate && \
    echo "abc ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create ping_host.sh with UNIX line endings; using HOST
RUN mkdir -p /usr/local/bin && \
    printf '#!/bin/sh\n[ -n "$HOST" ] && curl -fsS "$HOST" >/dev/null\n' > /usr/local/bin/ping_host.sh && \
    chmod 755 /usr/local/bin/ping_host.sh && \
    dos2unix /usr/local/bin/ping_host.sh

# Use the base image's built-in cron service (do not override /etc/services.d/cron)

# Set a default environment variable for HOST (can be overridden at runtime)
ENV HOST=http://example.com

# Use LinuxServer's custom init mechanism: add custom scripts in /custom-cont-init.d
RUN mkdir -p /custom-cont-init.d && \
    printf '#!/bin/sh\n\
if [ ! -f /swapfile ]; then\n\
    dd if=/dev/zero of=/swapfile bs=1M count=2048\n\
    chmod 600 /swapfile\n\
    mkswap /swapfile\n\
fi\n\
swapon /swapfile || true\n\
grep -qxF "/swapfile none swap sw 0 0" /etc/fstab || echo "/swapfile none swap sw 0 0" >> /etc/fstab\n' \
    > /custom-cont-init.d/10-swap && \
    chmod 755 /custom-cont-init.d/10-swap && \
    dos2unix /custom-cont-init.d/10-swap && \
    printf '#!/bin/sh\n\
echo "Updating abc user crontab for pinger."\n\
(crontab -u abc -l 2>/dev/null; echo "*/15 * * * * /usr/local/bin/ping_host.sh") | crontab -u abc -\n\
echo "abc user crontab:"\n\
crontab -u abc -l\n' \
    > /custom-cont-init.d/20-create-cron && \
    chmod 755 /custom-cont-init.d/20-create-cron && \
    dos2unix /custom-cont-init.d/20-create-cron
