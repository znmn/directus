# Use the official NocoDB image as base
FROM nocodb/nocodb:latest

# Expose the default NocoDB port
EXPOSE 8080

# Create and define the volume mount point
VOLUME /usr/app/data/
