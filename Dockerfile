FROM docker.n8n.io/n8nio/n8n

# Set the working directory
WORKDIR /home/node/.n8n

# Switch to root to install necessary packages
USER root
RUN apk add --no-cache curl ffmpeg imagemagick \
    && addgroup -S docker || true \
    && adduser node docker \
    && curl -o /home/node/DigiCertGlobalRootCA.crt.pem https://www.digicert.com/CACerts/DigiCertGlobalRootCA.crt.pem

# Switch back to node user
USER node
