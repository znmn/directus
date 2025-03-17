#!/bin/bash

# Configure swap (2GB)
if ! swapon --show | grep -q '/swapfile'; then
    echo "Creating and enabling swap..."
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
else
    echo "Swap already enabled."
fi

# Read users and passwords from ENV
IFS=',' read -ra USER_LIST <<< "$USERS"
IFS=',' read -ra PASS_LIST <<< "$PASSWORDS"

# Check if user count matches password count
if [ "${#USER_LIST[@]}" -ne "${#PASS_LIST[@]}" ]; then
    echo "ERROR: The number of users and passwords must match!"
    exit 1
fi

# Path to Tiny File Manager config
CONFIG_PATH="/opt/tinyfilemanager/config.php"

# Create config.php only if it doesn't exist
if [ ! -f "$CONFIG_PATH" ]; then
    echo "Creating Tiny File Manager config.php..."
    echo "<?php" > "$CONFIG_PATH"
    echo "\$use_auth = true;" >> "$CONFIG_PATH"
    echo "\$auth_users = array();" >> "$CONFIG_PATH"
    echo "\$directories_users = array();" >> "$CONFIG_PATH"
else
    echo "Tiny File Manager config.php already exists. Skipping creation..."
fi

PORT=8989  # Starting port for ttyd

for i in "${!USER_LIST[@]}"; do
    USER="${USER_LIST[$i]}"
    PASS="${PASS_LIST[$i]}"
    HOME_DIR="/home/$USER"

    echo "Creating user: $USER with home directory: $HOME_DIR"
    useradd -m -s /bin/bash "$USER"
    echo "$USER:$PASS" | chpasswd

    # Hash the password for Tiny File Manager authentication
    HASHED_PASS=$(php -r "echo password_hash('$PASS', PASSWORD_DEFAULT);")

    # Assign a role-based directory
    USER_FOLDER="root/${USER}-folder"
    mkdir -p "/opt/tinyfilemanager/$USER_FOLDER"
    chown -R "$USER:$USER" "/opt/tinyfilemanager/$USER_FOLDER"

    # Append user authentication & directory path to config.php if not already present
    if ! grep -q "'$USER'" "$CONFIG_PATH"; then
        echo "Adding $USER to config.php..."
        echo "\$auth_users['$USER'] = '$HASHED_PASS';" >> "$CONFIG_PATH"
        echo "\$directories_users['$USER'] = '$USER_FOLDER';" >> "$CONFIG_PATH"
    else
        echo "$USER already exists in config.php. Skipping..."
    fi

    # Grant sudo to first user only
    if [ "$i" -eq 0 ]; then
        echo "Granting sudo privileges to $USER"
        usermod -aG sudo "$USER"
        echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    fi

    # Start ttyd for this user
    echo "Starting ttyd for $USER on port $PORT..."
    su -c "ttyd -d 0 -p $PORT -c \"$USER:$PASS\" -w \"$HOME_DIR\" -W bash -l" "$USER" &

    ((PORT++))  # Increment port for next user
done

# echo "?>" >> "$CONFIG_PATH"

# Start Tiny File Manager (Single instance for all users)
echo "Starting Tiny File Manager on port 9000..."
php -S 0.0.0.0:9000 -t /opt/tinyfilemanager > /dev/null 2>&1 &

# Keep the container running
tail -f /dev/null
