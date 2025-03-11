FROM ubuntu:22.04

# Set timezone environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Jakarta

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    build-essential \
    cmake \
    git \
    libjson-c-dev \
    libwebsockets-dev \
    python3 \
    python3-pip \
    nodejs \
    npm \
    php \
    php-common \
    php-curl \
    screen \
    tzdata \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && npm install -g pnpm \
    && rm -rf /var/lib/apt/lists/*

# Clone and build ttyd
RUN git clone https://github.com/tsl0922/ttyd.git /opt/ttyd \
    && cd /opt/ttyd \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install \
    && rm -rf /opt/ttyd

# Expose port
EXPOSE 8989

# Set environment variables for user authentication
ENV TTYD_USER "admin"
ENV TTYD_PASS "password"

# Run ttyd on container start
CMD ttyd -p 8989 -c "$TTYD_USER:$TTYD_PASS" -W bash
