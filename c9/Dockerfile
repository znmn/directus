FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Environment variables
ENV TZ=Asia/Jakarta
ENV USERNAME=user
ENV PASSWORD=password
ENV PORT=8000

# Install base dependencies with Python 2.7 build requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
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
    && rm -rf /var/lib/apt/lists/*

# Install Python 2.7 from source
RUN curl -O https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz \
    && tar xzf Python-2.7.18.tgz \
    && cd Python-2.7.18 \
    && ./configure --enable-optimizations \
    && make altinstall \
    && ln -s /usr/local/bin/python2.7 /usr/local/bin/python \
    && cd .. \
    && rm -rf Python-2.7.18*

# Install Node.js 14.x (last version with good Python 2.7 compatibility)
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs \
    && npm config set python /usr/local/bin/python \
    && rm -rf /var/lib/apt/lists/*

# Create user and set permissions
RUN useradd -m -s /bin/bash "$USERNAME" \
    && echo "$USERNAME:$PASSWORD" | chpasswd \
    && usermod -aG sudo "$USERNAME" \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Clone and setup Cloud9 SDK
RUN git clone https://github.com/c9/core.git /c9sdk \
    && cd /c9sdk \
    && scripts/install-sdk.sh \
    && chown -R $USERNAME:$USERNAME /c9sdk

# Install remaining dependencies with legacy Python
RUN cd /c9sdk \
    && npm install --unsafe-perm \
    && npm install amd-loader \
    && npm cache clean --force

EXPOSE ${PORT}

COPY c9/entry.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER $USERNAME
WORKDIR /c9sdk
CMD ["/bin/bash", "/entrypoint.sh"]
