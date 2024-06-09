#!/bin/bash

# -----------------------------------------------
# Replace the value of WEBHOOK_URL with your own
# -----------------------------------------------
WEBHOOK_URL="https://discord.com/api/webhooks/1234567890/ABCDEFGHIJKLMN1234567890"
# -----------------------------------------------

# Get location using IP address
get_location() {
    IP=$1
    RESPONSE=$(curl -s "http://ip-api.com/json/$IP")
    CITY=$(echo $RESPONSE | awk -F'city":"' '{print $2}' | awk -F'"' '{print $1}')
    REGION=$(echo $RESPONSE | awk -F'regionName":"' '{print $2}' | awk -F'"' '{print $1}')
    COUNTRY=$(echo $RESPONSE | awk -F'country":"' '{print $2}' | awk -F'"' '{print $1}')

    if [[ -z "$CITY" ]]; then
        CITY="N/A"
    fi
    if [[ -z "$REGION" ]]; then
        REGION="N/A"
    fi
    if [[ -z "$COUNTRY" ]]; then
        COUNTRY="N/A"
    fi

    LOCATION="${CITY}, ${REGION}, ${COUNTRY}"
    echo "$LOCATION"
}

# Send a message to Discord using curl
send_discord_message() {
    USER=$1
    IP=$2
    LOCATION=$3
    TIME=$(date +"%Y-%m-%d %H:%M:%S")
    HOSTNAME=$(hostname)

    MESSAGE="**New SSH Login Alert**\n\n**User:** $USER\n**IP Address:** $IP\n**Location:** $LOCATION\n**Time:** $TIME\n**Hostname:** $HOSTNAME"

    curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$MESSAGE\"}" $WEBHOOK_URL  > /dev/null 2>&1 &
    disown
}

main() {
    # Check if SSH connection
    if [ -n "$SSH_CLIENT" ]; then
        # Extract the IP address of the client
        IP=$(echo $SSH_CLIENT | awk '{print $1}')

        # Get the username
        USER=$(whoami)

        # Get the location of the IP address
        LOCATION=$(get_location $IP)

        # Send the message to Discord
        send_discord_message "$USER" "$IP" "$LOCATION"
    fi
}

main &