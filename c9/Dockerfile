FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Environment variables
ENV TZ=Asia/Jakarta
ENV USERNAME=user
ENV PASSWORD=password
ENV PORT=8000

# Install base dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata \
    sudo \
    git \
    python3 \
    python3-pip \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 18.x (Cloud9 works best with LTS versions)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
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

# Install required Node modules
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
