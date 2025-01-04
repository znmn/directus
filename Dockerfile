# Start from the official Directus image
FROM directus/directus:11.3.5

# Example: (Optional) Install additional packages your project may need
# RUN apk add --no-cache some-package

# Example: (Optional) Copy in your custom extensions if you don't mount them as volumes
# COPY ./extensions /directus/extensions

# You can set environment variables here,
# but typically these are passed in at runtime via docker-compose.yml
ENV SECRET="replace-with-secure-random-value" \
    ADMIN_EMAIL="admin@example.com" \
    ADMIN_PASSWORD="d1r3ctu5" \
    DB_CLIENT="sqlite3" \
    DB_FILENAME="/directus/database/data.db" \
    WEBSOCKETS_ENABLED="true"

# Expose Directus’s default port
EXPOSE 8055

# The default entrypoint/cmd in the Directus image runs "directus start"
# so you usually don’t need to change it unless you have a custom process.
CMD ["directus", "start"]
