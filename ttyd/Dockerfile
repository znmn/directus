# Dockerfile
FROM ubuntu:22.04

# Set timezone environment variables to avoid interactive prompts
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

# Set environment variables for user authentication
ENV TTYD_USER="zain"
ENV TTYD_PASS="password"
ENV TTYD_PORT=8989

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

# Expose ports
EXPOSE $TTYD_PORT

# Switch to the created user and run ttyd
USER $TTYD_USER
CMD ttyd -d 0 -p "$TTYD_PORT" -c "$TTYD_USER:$TTYD_PASS" -W bash
