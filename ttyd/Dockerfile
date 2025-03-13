# Dockerfile
FROM ubuntu:22.04

# Set timezone environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Jakarta

# Install dependencies, including sudo
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    nano \
    sudo \
    build-essential \
    cmake \
    git \
    libjson-c-dev \
    libwebsockets-dev \
    python3 \
    python3-pip \
    php \
    php-common \
    php-curl \
    screen \
    tzdata \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/*

# Install latest Node.js (LTS) & npm from NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - \
    && apt-get install -y nodejs \
    && npm install -g pnpm

# Configure swap (2GB)
RUN sudo fallocate -l 2G /swapfile \
    && chmod 600 /swapfile \
    && mkswap /swapfile \
    && swapon /swapfile \
    && echo '/swapfile none swap sw 0 0' >> /etc/fstab

# Define users and passwords dynamically
ENV USERS="zain,user1,user2,user3,user4"
ENV PASSWORDS="pass1,pass2,pass3,pass4,pass5"
ENV START_PORT=8989

# Copy startup script
COPY ttyd/start.sh /start.sh
RUN chmod +x /start.sh

# Expose ports (assuming max 10 users)
EXPOSE 8989-8999

# Run startup script to launch ttyd for all users
CMD ["/bin/bash", "/start.sh"]
