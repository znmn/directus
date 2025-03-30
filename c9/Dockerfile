FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Environment variables
ENV TZ=Asia/Jakarta \
    USERNAME=user \
    PASSWORD=password \
    PORT=8000 \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Install base dependencies with locale configuration
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    locales \
    tzdata \
    sudo \
    git \
    curl \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    libreadline-dev \
    libgdbm-dev \
    libnss3-dev \
    libsqlite3-dev \
    libffi-dev \
    libevent-dev \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# Install Python 2.7 from source
RUN curl -kO https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz \
    && tar xzf Python-2.7.18.tgz \
    && cd Python-2.7.18 \
    && ./configure --enable-optimizations \
        --with-ensurepip=install \
        --enable-shared \
        LDFLAGS="-Wl,-rpath=/usr/local/lib" \
    && make -j$(nproc) altinstall \
    && ldconfig \
    && ln -s /usr/local/bin/python2.7 /usr/local/bin/python \
    && cd .. \
    && rm -rf Python-2.7.18*

# Install Node.js 14.x
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs \
    && npm config set python /usr/local/bin/python \
    && rm -rf /var/lib/apt/lists/*

# Create user and set permissions
RUN useradd -m -s /bin/bash "$USERNAME" \
    && echo "$USERNAME:$PASSWORD" | chpasswd \
    && usermod -aG sudo "$USERNAME" \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Clone and setup Cloud9 SDK with locale settings
RUN git clone https://github.com/c9/core.git /c9sdk \
    && cd /c9sdk \
    && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 scripts/install-sdk.sh \
    && chown -R $USERNAME:$USERNAME /c9sdk

# # Install remaining dependencies
# RUN cd /c9sdk \
#     && npm install --unsafe-perm \
#     && npm install amd-loader \
#     && npm cache clean --force

EXPOSE ${PORT}

COPY c9/entry.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER $USERNAME
WORKDIR /c9sdk
CMD ["/bin/bash", "/entrypoint.sh"]
