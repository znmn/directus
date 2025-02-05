FROM docker.n8n.io/n8nio/n8n

# Set the working directory
WORKDIR /home/node/.n8n

# Switch to root to install necessary packages
USER root
RUN apk add --no-cache curl ffmpeg \
    && addgroup -S docker || true \
    && adduser node docker

# Switch back to node user
USER node

# Expose the n8n port
EXPOSE 5678

# Command to run n8n
CMD ["n8n"]
