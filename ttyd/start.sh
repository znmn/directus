#!/bin/bash

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

    echo "Creating user: $USER"
    useradd -m -s /bin/bash "$USER"
    echo "$USER:$PASS" | chpasswd
    usermod -aG sudo "$USER"
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

    echo "Starting ttyd for $USER on port $PORT..."
    su -c "ttyd -d 0 -p $PORT -c \"$USER:$PASS\" -W bash" "$USER" &
    
    ((PORT++))
done

# Keep the container running
tail -f /dev/null
