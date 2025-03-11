FROM ubuntu:latest
LABEL maintainer="Zainul M <zain.email@example.com>"

# Disable interactive prompts during package installation.
ENV DEBIAN_FRONTEND=noninteractive

# Set default environment variables for Cloud9 authentication and port.
ENV C9_USER=defaultuser
ENV C9_PASSWORD=defaultpassword
ENV PORT=8181

# Install prerequisites including python, nodejs, npm, PHP, Git, screen, and curl.
RUN apt-get update && \
    apt-get install -y python3 nodejs npm libapache2-mod-php php php-common php-curl git screen curl && \
    # Ensure 'node' is available (Ubuntu sometimes installs it as 'nodejs')
    if [ ! -e /usr/bin/node ]; then ln -sf /usr/bin/nodejs /usr/bin/node; fi && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Clone the Cloud9 core repository.
WORKDIR /opt
RUN git clone https://github.com/c9/core.git c9sdk

# Change working directory to the Cloud9 SDK and run its installation script.
WORKDIR /opt/c9sdk
RUN chmod +x scripts/install-sdk.sh && ./scripts/install-sdk.sh

# Expose the port (default 8181) so the IDE can be accessed externally.
EXPOSE ${PORT}

# Start Cloud9 binding to all interfaces, using the provided credentials.
CMD ["sh", "-c", "node server.js -l 0.0.0.0 -p $PORT -a $C9_USER:$C9_PASSWORD"]
