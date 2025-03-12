# Use Nginx Proxy Manager as the base image
FROM jc21/nginx-proxy-manager:latest

# Set timezone environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Jakarta \
    DISABLE_IPV6=true \
    TTYD_USER="zain" \
    TTYD_PASS="password" \
    TTYD_PORT=8989

# Install additional dependencies
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

# Create a new user dynamically using TTYD_USER
RUN useradd -m -s /bin/bash "$TTYD_USER" \
    && echo "$TTYD_USER:$TTYD_PASS" | chpasswd \
    && usermod -aG sudo "$TTYD_USER" \
    && echo "$TTYD_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set working directory for the user
WORKDIR /home/$TTYD_USER

# Clone and build ttyd
RUN git clone https://github.com/tsl0922/ttyd.git /opt/ttyd \
    && cd /opt/ttyd \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install \
    && rm -rf /opt/ttyd

# Expose necessary ports for ttyd and Nginx Proxy Manager
EXPOSE $TTYD_PORT 80 443 81

# Default command to start both services
CMD ttyd -d 0 -p "$TTYD_PORT" -c "$TTYD_USER:$TTYD_PASS" -W bash & /init
