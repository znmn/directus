# Use an official Ubuntu base image
FROM ubuntu:latest

# Set environment variables to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install OpenSSH Server and a simple HTTP server
RUN apt-get update && apt-get install -y \
    openssh-server \
    apache2 \
    && rm -rf /var/lib/apt/lists/*

# Create SSH directory
RUN mkdir /var/run/sshd

# Create a user for SSH access
RUN useradd -m -s /bin/bash user && echo "user:password" | chpasswd

# Allow root login and password authentication (not recommended for production)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Expose SSH and HTTP ports
EXPOSE 22 80

# Start SSH and HTTP services
CMD service apache2 start && /usr/sbin/sshd -D
