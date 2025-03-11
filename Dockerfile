FROM ubuntu:latest
LABEL maintainer="Zainul M <zain.email@example.com>"

# Disable interactive prompts during package installation.
ENV DEBIAN_FRONTEND=noninteractive

# Set default environment variables for Cloud9 authentication and port.
ENV C9_USER=user
ENV C9_PASSWORD=password
ENV PORT=8181

# Install prerequisites: Node.js, npm, and Git.
RUN apt-get update && \
    apt-get install -y nodejs npm git && \
    # Ensure "node" is available (Ubuntu sometimes installs as "nodejs")
    ln -sf /usr/bin/nodejs /usr/bin/node && \
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
