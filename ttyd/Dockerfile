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

# Define users and passwords dynamically
ENV USERS="zain,user1,user2,user3,user4"
ENV PASSWORDS="pass1,pass2,pass3,pass4,pass5"
ENV START_PORT=8989

# Copy startup script
COPY ttyd/start.sh /start.sh
RUN chmod +x /start.sh

# Clone and build ttyd
RUN git clone https://github.com/tsl0922/ttyd.git /opt/ttyd \
    && cd /opt/ttyd \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install \
    && rm -rf /opt/ttyd
    
# Expose ports (assuming max 10 users)
EXPOSE 8989-8999

# Run startup script to launch ttyd for all users
CMD ["/bin/bash", "/start.sh"]
