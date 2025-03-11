FROM ubuntu:22.04
LABEL maintainer="Zainul M <zain.email@example.com>"

# Disable interactive prompts during package installation.
ENV DEBIAN_FRONTEND=noninteractive

# Set locale environment variables to ensure UTF-8 support.
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Set default environment variables for Cloud9 authentication and port.
ENV C9_USER=defaultuser
ENV C9_PASSWORD=defaultpassword
ENV PORT=8181

# Install locales and generate en_US.UTF-8.
RUN apt-get update && \
    apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
    
# Install prerequisites including Python2 (via python2-minimal), Node.js, npm, PHP, Git, screen, and curl.
RUN apt-get update && \
    apt-get install -y python2-minimal nodejs npm libapache2-mod-php php php-common php-curl git screen curl && \
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
