FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Environment variables
ENV TZ=Asia/Jakarta
ENV USERNAME=user
ENV PASSWORD=password
ENV PORT=8000

# Install base dependencies with Python 2.7
RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata \
    sudo \
    git \
    curl \
    build-essential \
    python2.7 \
    python-is-python2 \
    && rm -rf /var/lib/apt/lists/*

# Add Python 2.7 symlink and set as default for npm
RUN ln -s /usr/bin/python2.7 /usr/bin/python \
    && npm config set python /usr/bin/python

# Install Node.js 16.x (more compatible with Cloud9 Core)
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Create user and set permissions
RUN useradd -m -s /bin/bash "$USERNAME" \
    && echo "$USERNAME:$PASSWORD" | chpasswd \
    && usermod -aG sudo "$USERNAME" \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Clone and setup Cloud9 SDK with Python 2.7
RUN git clone https://github.com/c9/core.git /c9sdk \
    && cd /c9sdk \
    && scripts/install-sdk.sh \
    && chown -R $USERNAME:$USERNAME /c9sdk

# Install remaining dependencies
RUN cd /c9sdk \
    && npm install \
    && npm install amd-loader \
    && npm cache clean --force

EXPOSE ${PORT}

COPY c9/entry.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER $USERNAME
WORKDIR /c9sdk
CMD ["/bin/bash", "/entrypoint.sh"]
