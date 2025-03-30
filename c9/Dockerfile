FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables (defaults provided)
ENV TZ=Asia/Jakarta
ENV USERNAME=user
ENV PASSWORD=password
ENV PORT=8000

# Set timezone using tzdata
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

# Create a new user and add to sudoers without password prompt
RUN useradd -m -s /bin/bash "$USERNAME" && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    usermod -aG sudo "$USERNAME" && \
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install Cloud9 SDK globally via npm
RUN npm install -g c9

# Expose the specified port (default 8000)
EXPOSE ${PORT}

# Copy the unified entrypoint shell script and make it executable
COPY c9/entry.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Use the entrypoint script to create swap and run Cloud9 SDK
CMD ["/entrypoint.sh"]
