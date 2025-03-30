FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables (default values if not provided)
ENV TZ=Asia/Jakarta
ENV USERNAME=user
ENV PASSWORD=password
ENV PORT=8000

# Set timezone
RUN apt-get update && apt-get install -y --no-install-recommends tzdata && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    rm -rf /var/lib/apt/lists/*

# Install required packages (including cron) with --no-install-recommends
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    nano \
    git \
    php \
    python3 \
    python3-pip \
    curl \
    cron && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js (latest) from NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get update && apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/*

# Create and enable a 2GB swap file
RUN fallocate -l 2G /swapfile && \
    chmod 600 /swapfile && \
    mkswap /swapfile && \
    swapon /swapfile

# Create a new user and add to sudoers without password prompt
RUN useradd -m -s /bin/bash "$USERNAME" && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    usermod -aG sudo "$USERNAME" && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Cloud9 SDK globally via npm
RUN npm install -g c9

# Expose the specified port (default 8000)
EXPOSE ${PORT}

# Start Cloud9 SDK with basic authentication using the USERNAME and PASSWORD
CMD ["sh", "-c", "c9sdk -l 0.0.0.0 -p ${PORT} -a ${USERNAME}:${PASSWORD}"]
