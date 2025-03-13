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

# Assign ports dynamically starting from START_PORT
PORT=$START_PORT

for i in "${!USER_LIST[@]}"; do
    USER="${USER_LIST[$i]}"
    PASS="${PASS_LIST[$i]}"
    HOME_DIR="/home/$USER"

    echo "Creating user: $USER with home directory: $HOME_DIR"
    useradd -m -s /bin/bash "$USER"
    echo "$USER:$PASS" | chpasswd

    if [ "$i" -eq 0 ]; then
        echo "Granting sudo privileges to $USER"
        usermod -aG sudo "$USER"
        echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    fi

    echo "Starting ttyd for $USER on port $PORT in $HOME_DIR..."
    su -c "cd $HOME_DIR && ttyd -d 0 -p $PORT -c \"$USER:$PASS\" -W bash -l" "$USER" &

    ((PORT++))
done

# Keep the container running
tail -f /dev/null
